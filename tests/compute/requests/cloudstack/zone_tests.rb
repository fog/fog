Shindo.tests('Fog::Compute[:cloudstack] | zone requests', ['cloudstack']) do

  @zones_format = {
    'listzonesresponse'  => {
      'count' => Integer,
      'zone' => [
        'id' => Integer,
        'name' => String,
        'dns1' => String,
        'dns2' => String,
        'internaldns1' => String,
        'internaldns2' => String,
        'vlan' => String,
        'guestcidraddress' => String,
        'networktype' => String,
        'securitygroupsenabled' => [TrueClass,FalseClass],
        'allocationstate' => String,
        'dhcpprovider' => String
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
