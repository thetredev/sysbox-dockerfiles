# sysbox dockerfiles

....

# peristency

just a reminder for me atm

```
# terminal 1
docker run --rm --entrypoint bash --name export-container -it <image>

# terminal 2
mkdir -p /some/path/to/persist/data
cd /some/path/to/persist/data

docker export export-container > container.tar
docker rm -f export-container

tar xf container.tar

rm -rf $(ls -d -1 ./* | grep -v '/bin\|/etc\|/lib\|/lib64\|/root\|/sbin\|/usr\|/var')
rm -rf ./var/run
```

compose:

```yaml
.....

  ports:
    # master nodes only
    - 6443:6443

    # all nodes
    - 10250:10250

  volumes:
    - /some/path/to/persist/data/etc:/etc
    ...
```
