Shindo.tests('Fog::Compute[:cloudstack] | virtual machine requests', ['cloudstack']) do

  @virtual_machines_format = {
    'listvirtualmachinesresponse'  => {
      'count' => Integer,
      'virtualmachine' => [
        'id' => Integer,
        'name' => String,
        'displayname' => String,
        'account' => String,
        'domainid' => Integer,
        'domain' => String,
        'created' => String,
        'state' => String,
        'haenable' => Fog::Boolean,
        'zoneid' => Integer,
        'zonename' => String,
        'hostid' => Fog::Nullable::String,
        'hostname' => Fog::Nullable::String,
        'templateid' => Integer,
        'templatename' => String,
        'templatedisplaytext' => String,
        'passwordenabled' => Fog::Boolean,
        'serviceofferingid' => Integer,
        'serviceofferingname' => String,
        'cpunumber' => Integer,
        'cpuspeed' => Integer,
        'networkkbsread' => Fog::Nullable::Integer,
        'memory' => Integer,
        'cpuused' => Fog::Nullable::String,
        'guestosid' => Integer,
        'networkkbswrite' => Fog::Nullable::Integer,
        'rootdeviceid' => Integer,
        'rootdevicetype' => String,
        'hypervisor' => String,
        'group' => Fog::Nullable::String,
        'groupid' => Fog::Nullable::Integer,
        'isoname' => Fog::Nullable::String,
        'isoid' => Fog::Nullable::Integer,
        'securitygroup' => [
           'id' => Integer,
           'name' => Fog::Nullable::String,
           'description' => Fog::Nullable::String
        ],
        'nic' => [
          'id' => Integer,
          'networkid' => Integer,
          'netmask' => String,
          'gateway' => String,
          'ipaddress' => String,
          'traffictype' => String,
          'type' => String,
          'isdefault' => Fog::Boolean,
          'macaddress' => String,
          'broadcasturi' => Fog::Nullable::String,
          'isolationuri' => Fog::Nullable::String
        ]
      ]
    }
  }

  tests('success') do

    tests('#list_virtual_machines').formats(@virtual_machines_format) do
      pending if Fog.mocking?
      Fog::Compute[:cloudstack].list_virtual_machines
    end

  end

end