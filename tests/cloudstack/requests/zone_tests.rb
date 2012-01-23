Shindo.tests('Fog::Compute[:cloudstack] | zone requests', ['cloudstack']) do

  @zones_format = {
    'listzonesresponse'  => {
      'count' => Integer,
      'zone' => [
        'id' => Integer,
        'name' => String,
        'dns1' => Fog::Nullable::String,
        'dns2' => Fog::Nullable::String,
        'internaldns1' => Fog::Nullable::String,
        'internaldns2' => Fog::Nullable::String,
        'vlan' => Fog::Nullable::String,
        'guestcidraddress' => Fog::Nullable::String,
        'networktype' => String,
        'securitygroupsenabled' => Fog::Nullable::Boolean,
        'allocationstate' => String,
        'dhcpprovider' => String,
        'zonetoken' => Fog::Nullable::String
      ]
    }
  }

  tests('success') do

    tests('#list_zones').formats(@zones_format) do
      pending if Fog.mocking?
      Fog::Compute[:cloudstack].list_zones
    end

  end

end
