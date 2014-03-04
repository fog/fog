# Description
The openvz provider implements a simple mapping between openvz commands and fog

# Usage
## Establish a connection
    openvz = ::Fog::Compute.new( {:provider => 'openvz'})

Additional option is **:openvz_connect_command**:
It allows you to specify connect command to connect to the openvz server, if it's not localhost.

- This is specified as a string where the '@command@' placeholder will be replaced when the commands are executed
- The @command@ will contain double quotes, therefore make sure you use single quotes only inside the placeholder

To connect to a remote ssh server myopenvzserver and sudo excute the command

    openvz = ::Fog::Compute.new( {
      :provider => 'openvz',
      :openvz_connect_command => "ssh myopenvzserver 'sudo @command'"
    })

## List servers

    openvz = ::Fog::Compute.new( {:provider => 'openvz'})
    servers = openvz.servers.all
    servers.each do |s|
      puts c.ctid
    end

## Server Unique id
Servers have the ctid as identity.

## Get a specific server

    openvz = ::Fog::Compute.new( {:provider => 'openvz'})
    server = openvz.servers.get(104)

## Server lifecycle

    openvz = ::Fog::Compute.new( {:provider => 'openvz'})
    # Create a server
    server = openvz.servers.create(
      :ctid       => '104',
      :ostemplate => 'ubuntu-12.04-x86_64',
      :diskspace  => 1024*1024 #in kbyte
    )
    server.reload

    # Start a server
    unless server.status == 'running'
      server.start
    end

    server.set({
      :nameserver => '8.8.8.8',
      :ipadd => '192.168.8.10',
      :ram => '380M',
      :hostname => 'wonderfullserver',
      :name => 'chef',
      :description => 'wonderfullserver',
      :save => true
    })

    # Reboot a server
    server.reboot
    sleep 3

    # Get the ipaddress
    puts "ipaddress: #{server.public_ip_address}"

    server.wait_for { status == 'running' }

    # Stop the server
    server.stop

    # Destroy the server
    server.destroy

## Models
Both compute::server and computer::servers (collections) have been implemented

Note:
- server.save can only be called upon creation, use the server.set command to change the settings
- server.public_ip_address will only return the first ip address
- TODO: snapshots could be implemented as a collection
- server.state has the standard openvz states.
- server.ready? assumes server.status == 'running'

## Requests
### Passing parameters
The server request are in essence a passthrough to __vzctl__.
Just provide the options as a hash in key,value pairs.
If it's just a switch (like --save), use a key and a boolean(true).

The following command in plain cli-vzctl:

    vzctl set 104 --nameserver 8.8.8.8 --ipadd 192.168.8.10 --ram '380M'

Would be in fog-speak:

    server = openvz.servers.get(104)
    server.set({
      :nameserver => '8.8.8.8',
      :ipadd      => '192.168.8.10',
      :ram        => '380M',
      :save       => true
    })

To specify multiple values for the same option pass an array

    server.set({
      :nameserver => ['8.8.8.8','7.7.7.7'],
      :ipadd      => ['192.168.8.10','192.168.4.10'],
      :ram        => '380M',
      :save       => true
    })

### Passing arguments
both exec, exec2 and runscript take no parameters just arguments

    server = openvz.servers.get(104)
    uname_output = server.exec("uname -a")

### Not implemented
From all the options to vzctl (see below) the following commands have **NOT** been implemented:

- console : as it requires direct input

## VZCTL commands

the current version of the fog openvz driver is based on the following vzctl syntax

    vzctl version 4.3
    Copyright (C) 2000-2012, Parallels, Inc.
    This program may be distributed under the terms of the GNU GPL License.

    Usage: vzctl [options] <command> <ctid> [parameters]

    vzctl create <ctid> [--ostemplate <name>] [--config <name>]
       [--layout ploop|simfs] [--hostname <name>] [--name <name>] [--ipadd <addr>]
       [--diskspace <kbytes>] [--private <path>] [--root <path>]
       [--local_uid <UID>] [--local_gid <GID>]
    vzctl start <ctid> [--force] [--wait]
    vzctl destroy | mount | umount | stop | restart | status <ctid>
    vzctl convert <ctid> [--layout ploop[:mode]] [--diskspace <kbytes>]
    vzctl compact <ctid>
    vzctl snapshot <ctid> [--id <uuid>] [--name <name>] [--description <desc>]
       [--skip-suspend]
    vzctl snapshot-switch | snapshot-delete <ctid> --id <uuid>
    vzctl snapshot-mount <ctid> --id <uuid> --target <dir>
    vzctl snapshot-umount <ctid> --id <uuid>
    vzctl snapshot-list <ctid> [-H] [-o field[,field...]] [--id <uuid>]
    vzctl quotaon | quotaoff | quotainit <ctid>
    vzctl console <ctid> [ttyno]
    vzctl enter <ctid> [--exec <command> [arg ...]]
    vzctl exec | exec2 <ctid> <command> [arg ...]
    vzctl runscript <ctid> <script>
    vzctl suspend | resume <ctid> [--dumpfile <name>]
    vzctl set <ctid> [--save] [--force] [--setmode restart|ignore]
       [--ram <bytes>[KMG]] [--swap <bytes>[KMG]]
       [--ipadd <addr>] [--ipdel <addr>|all] [--hostname <name>]
       [--nameserver <addr>] [--searchdomain <name>]
       [--onboot yes|no] [--bootorder <N>]
       [--userpasswd <user>:<passwd>]
       [--cpuunits <N>] [--cpulimit <N>] [--cpus <N>] [--cpumask <cpus>]
       [--diskspace <soft>[:<hard>]] [--diskinodes <soft>[:<hard>]]
       [--quotatime <N>] [--quotaugidlimit <N>] [--mount_opts <opt>[,<opt>...]]
       [--capability <name>:on|off ...]
       [--devices b|c:major:minor|all:r|w|rw]
       [--devnodes device:r|w|rw|none]
       [--netif_add <ifname[,mac,host_ifname,host_mac,bridge]]>]
       [--netif_del <ifname>]
       [--applyconfig <name>] [--applyconfig_map <name>]
       [--features <name:on|off>] [--name <vename>] [--ioprio <N>]
       [--pci_add [<domain>:]<bus>:<slot>.<func>] [--pci_del <d:b:s.f>]
       [--iptables <name>] [--disabled <yes|no>]
       [UBC parameters]

    UBC parameters (N - items, P - pages, B - bytes):
    Two numbers divided by colon means barrier:limit.
    In case the limit is not given it is set to the same value as the barrier.
       --numproc N[:N]      --numtcpsock N[:N]      --numothersock N[:N]
       --vmguarpages P[:P]  --kmemsize B[:B]        --tcpsndbuf B[:B]
       --tcprcvbuf B[:B]    --othersockbuf B[:B]    --dgramrcvbuf B[:B]
       --oomguarpages P[:P] --lockedpages P[:P]     --privvmpages P[:P]
       --shmpages P[:P]     --numfile N[:N]         --numflock N[:N]
       --numpty N[:N]       --numsiginfo N[:N]      --dcachesize N[:N]
       --numiptent N[:N]    --physpages P[:P]       --avnumproc N[:N]
       --swappages P[:P]
