This model implements the connection with a libvirt URI.
A libvirt URI can either be local or remote. 

To learn more on the specific libvirt URI syntax see:

- [http://libvirt.org/uri.html](http://libvirt.org/uri.html)
- [http://libvirt.org/remote.html#Remote_URI_reference](http://libvirt.org/remote.html#Remote_URI_reference)

Only ssh is supported as the transport for remote URI's. TLS is NOT supported, as we can't easily login to the server

## Dependencies

- the interaction with libvirt is done through the official libvirt gem called 'libvirt-ruby'.
- be aware that there is another libvirt gem called 'libvirt', which is not compatible
- If this gem is not installed the models for libvirt will not be available

- libvirt needs to be setup so that it can be used
- for a remote ssh connection this requires to be member of the libvirt group before you can use the libvirt commands
- verify if you can execute virsh command to see if you have correct access

## Libvirt on Macosx

- There is a libvirt client for Macosx, available via homebrew
- By default this will install things in /usr/local/somewhere
- This means that also the default locations of the libvirt-socket are assumed to be in /usr/local
- To check the connection you need to override your libvirt socket location in the URI
  - "qemu+ssh://patrick@myserver/system?socket=/var/run/libvirt/libvirt-sock"

## Configuration

The URI can be configured in two ways:
1) via the .fog file
:default
  :libvirt_uri: "qemu+ssh://patrick@myserver/system?socket=/var/run/libvirt/libvirt-sock"

2) you can also pass it during creation :
f=Fog::Compute.new(:provider => "Libvirt", :libvirt_uri => "qemu+ssh://patrick@myserver/system")

## IP-addresses of guests
Libvirt does not provide a way to query guests for Ip-addresses.
The way we solve this problem is by installing arpwatch: this watches an interface for new mac-addresses and ip-addresses requested by DHCP
We query that logfile for the mac-address and can retrieve the ip-address

vi /etc/rsyslog.d/30-arpwatch.conf
#:msg, contains, "arpwatch:" -/var/log/arpwatch.log
#& ~
if $programname =='arpwatch' then /var/log/arpwatch.log
& ~

This log files needs to be readable for the users of libvirt

## SSh-ing into the guests
Once we have retrieved the ip-address of the guest we can ssh into it. This works great if the URI is local.
But when the URI is remote our machine can't ssh directly into the guest sometimes (due to NAT or firewall issues)

Luckily libvirt over ssh requires netcat to be installed on the libvirt server.
We use this to proxy our ssh requests to the guest over the ssh connection to the libvirt server.
Thanks to the requirement that you need ssh login to work to a libvirt server, we can login and tunnel the ssh to the guest.

## Bridge configuration (slowness)
We had noticed that sometimes it takes about 30 seconds before the server gets a DHCP response from the server.
In our case it was because the new machine Mac-address was not allowed immediately by the bridge.
Adding the flag 'bridge_fd 0' solved that problem.

/etc/network/interfaces
auto br0
iface br0 inet static
address 10.247.4.13
netmask 255.255.255.0
network 10.247.4.0
broadcast 10.247.4.255
bridge_ports eth0.4
bridge_stp on
bridge_maxwait 0
bridge_fd 0

