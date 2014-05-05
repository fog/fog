# Getting started: the compute service

## Connecting, retrieving and managing server objects

First, create a connection to the XenServer host:

    require 'fog'
    require 'pp'

    #
    # http://rubydoc.info/github/fog/fog/Fog/Compute/XenServer/Real
    #
    conn = Fog::Compute.new({
      :provider => 'XenServer',
      :xenserver_url => 'xenserver-test',
      :xenserver_username => 'root',
      :xenserver_password => 'changeme',
      :xenserver_defaults => {
        :template => "squeeze-test"
      }
    })

## Listing servers (VMs) and templates

We try to follow fog naming conventions and behavior as much as we can, so the
terminology used in fog/xenserver is a little bit different from the one
used in XAPI/XenServer documents. In particular:

* A Fog::Compute::XenServer::Server is a XenServer VM or DomU

* A Fog::Compute::XenServer::Host is a Hypervisor or Dom0

Having that in mind, we can start doing things with out XenServer host.

Listing all the servers (VMs):

    conn.servers.all

This will return a list of Fog::Compute::XenServer::Server.

List all the servers whose name matches Ubuntu:

    conn.servers.all :name_matches => "Ubuntu"

Listing the first server running (templates aren't included by default
in the list):

    server = conn.servers.first

Listing custom templates, that is, the ones created by the user:

    custom = conn.servers.custom_templates

Listing built-in templates (the templates available after a fresh install):

    built_in = conn.servers.builtin_templates

Templates are regular Fog::Compute::XenServer::Server objects too, so you can
inspect some of their attributes. The relevant XAPI documentation:

http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=VM

Fog::Compute::XenServer::Server attributes and operations usually map to the
ones found in the official Citrix documentation, and they are available at:

http://rubydoc.info/github/fog/fog/Fog/Compute/XenServer/Server

and

https://github.com/fog/fog/blob/master/lib/fog/xenserver/models/compute/server.rb

## Server operations and attributes

Getting server VIFs (virtual network interfaces):

    # http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=VIF
    server.networks
    # or server.vifs

Listing the server VBDs (virtual block devices):

    # http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=VBD
    server.vbds


Get VDIs objects (virtual disk images) attached to the server:

    server.vbds.each do |vbd|
      # http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=VDI
      vdi = vbd.vdi
      # In bytes
      puts vdi.virtual_size
      puts vdi.physical_utilisation
    end

## Server creation and life-cycle management

Creating a new server/VM:

    server = conn.servers.create :name => 'foobar',
                                 :template_name => 'squeeze-test'

The server is automatically started after that.

Note that template_name is optional if you have specified the ':template'
parameter when when creating the connection.

If you don't want to automatically start the server, use 'new' instead of 'create':

    server = conn.servers.new :name => 'foobar',
                              :template_name => 'squeeze-test'

and set auto_start to false when saving it:

    server.save :auto_start => false

Shutting down the server, By forcing it

    server.stop 'hard'
    # server.hard_shutdown is equivalent

Doing a clean shutdown

    server.stop 'clean'
    # server.clean_shutdown is equivalent

And finally, destroy it (it will force a shutdown first if running):

    server.destroy

# XenServer Host (Dom0) operations

The are some operations that can be performed on the host, without retrieving
and/or manipulating servers:

Listing all the VBDs (virtual block devices):

    # http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=VBD
    conn.vbds.all

This will retrieve the list of every single VBD available in the XenServer.

Same thing applies to the virtual disk images:

    conn.vdis.all

Listing Storage Repositories (Xen SRs), where the disk images are stored:

    # http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=SR
    conn.storage_repositories


XenServer Pools:

    # http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=pool
    conn.pools


Retrieve the default storage repository in a pool:

    conn.pools.first.default_storage_repository
    # or the equivalent conn.pools.first.default_sr

