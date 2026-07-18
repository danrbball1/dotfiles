# Virt-Manager Configuration Change

Virt-Manager requires a change to default settings to allow for networking to work.

You need to update `/etc/libvirt/network.conf` to include `firewall_backend=iptables` by running the following command.

`sudo vim /etc/libvirt/network.conf`
