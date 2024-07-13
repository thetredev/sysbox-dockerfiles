# control plane

```
# create control plane config
cat > /tmp/k8s-master.yaml <<EOF
apiVersion: kubeadm.k8s.io/v1beta3
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  bindPort: 6443
nodeRegistration:
  criSocket: unix:///run/cri-dockerd.sock
  imagePullPolicy: IfNotPresent
  name: k8s-master
  taints: null
---
apiServer:
  timeoutForControlPlane: 4m0s
  certSANs:
    - "127.0.0.1"
    - "localhost"
apiVersion: kubeadm.k8s.io/v1beta3
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns: {}
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: registry.k8s.io
kind: ClusterConfiguration
kubernetesVersion: 1.30.0
networking:
  dnsDomain: cluster.local
  podSubnet: 10.244.0.0/16
  serviceSubnet: 10.96.0.0/12
scheduler: {}
EOF

# create k8s network
docker network create k8s

# create control plane
docker run -d \
    --runtime sysbox-runc \
    --network k8s \
    --name k8s-master \
    --hostname k8s-master \
    -v /etc/ssl:/etc/ssl:ro \
    -v /srv/k8s-master/etcd:/var/lib/etcd \
    -v /srv/k8s-master/config:/etc/kubernetes \
    -p 0.0.0.0:6443:6443 \
    ghcr.io/thetredev/sysbox-dockerfiles/debian/kindbox:latest

# copy control plane config
docker cp /tmp/k8s-master.yaml k8s-master:/tmp/kubeadm-config.yaml

# init kubernetes control plane
docker exec k8s-master kubeadm init --config /tmp/kubeadm-config.yaml

# copy kubectl config from container
mkdir -p ~/.kube/config
docker exec -it k8s-master cat /etc/kubernetes/admin.conf > ~/.kube/config

# wait until 2 coredns pods show up as Pending and all other pods are running
watch -n 1 kubectl -n kube-system get pod

# install flannel
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# wait all pods show up as Running
watch -n 1 kubectl get pod -A
```

# worker
```
# create worker node
docker run -d \
    --runtime sysbox-runc \
    --network k8s \
    --name k8s-worker-001 \
    --hostname k8s-worker-001 \
    -v /etc/ssl:/etc/ssl:ro \
    ghcr.io/thetredev/sysbox-dockerfiles/debian/kindbox:latest

# join cluster
kubeadm_join_command="$(docker exec -it k8s-master kubeadm token create --print-join-command) --cri-socket unix:///run/cri-dockerd.sock"
docker exec k8s-worker-001 kubeadm join ${kubeadm_join_command}

# wait until node is ready
watch -n 1 kubectl get node -o wide

# wait until cluster is ready
watch -n 1 kubectl get all -A
```
