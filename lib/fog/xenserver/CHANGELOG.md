# 1.10.1 2013/04/04

* It's now possible to manage XS/XCP VLANs and Networks

  See https://github.com/fog/fog/blob/master/lib/fog/xenserver/examples/networks-and-vlans.rb

# 1.9.0 2013/01/19

* Added missing HostCpu model

  So you can retrieve things like the CPU model, speed, flags
  utilisation, vendor, etc.

  See http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=host_cpu

* Host model improvements

  Added missing host attributes:

  - edition
  - software_version
  - enable
  - disable
  - shutdown
  - reboot

  See http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=host

* PBD model improvements

  - Added missing currently_attached attribute
  - A PBD can be unplugged now

  See http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=PBD

* StorageRepository model improvements

  - Added missing create/destroy/save operations
  - Added missing generic set_attribute method

  See http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=SR

* Pool model improvements

  - Added missing suspend_image_sr attribute
  - Added default_sr getter/setter
  - Added suspend_image_sr getter/setter
  - Added generic set_attribute method

  See http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=pool

* Switch to nokogiri XML parser

  Use Nokogiri instead of slow REXML for parsing, greatly improving
  parsing time under some ruby implementations.

* Greatly improved documentation

  New tutorials included with the provider:

  - Getting started: the compute service
  - How To Change the Default Storage Repository to File-based VHD-on-EXT3
  - Example that covers a Citrix KB ctx116324 article
  - Creating servers (VMs) and templates
  - Managing Storage Repositories

  See https://github.com/fog/fog/tree/master/lib/fog/xenserver/examples

* Added missing HostMetrics model

  Retrieve the metrics associated with a host.

  See http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=host_metrics

* Fixed authentication issues when using numeric-only passwords

* Better test coverage
