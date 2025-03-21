Simple docker configuration for running Pktgen-DPDK

To run:
```sh
# setup hugepages on the host
root@host>> /opt/mellanox/dpdk/bin/dpdk-hugepages.py -r8G

# build the docker image
root@host>> docker build -t dpdk-pktgen .

# enter the docker container
root@host>> docker run \
    --rm \
    --privileged \
    --network host \
    -v /sys/bus/pci/drivers:/sys/bus/pci/drivers \
    -v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages \
    -v /sys/devices/system/node:/sys/devices/system/node \
    -v /dev/hugepages:/dev/hugepages \
    -it \
    dpdk-pktgen

# find the PCI address you are going to run pktgen on
root@docker>> lshw -c network -businfo

# start pktgen
root@docker>> ./pktgen -a <PCI> -- -m 1.0
```

