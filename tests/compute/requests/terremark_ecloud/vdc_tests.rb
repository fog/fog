Shindo.tests('TerremarkEcloud::Compute | vdc requests', ['terremark_ecloud']) do

  @vdc_format = {
    'name' => String,
    'uri'  => String,
    'catalog_uri' => String,
    'publicIpsList_uri' => String,
    'internetServicesList_uri' => String,
    'firewallAclsList_uri' => String,
    'trustedNetworkGroupsList_uri' => String,
    'storageCapacity' => {
      'allocated' => Integer,
      'used'      => Integer
    },
    'cpuCapacity' => {
      'allocated' => Integer
    },
    'memoryCapacity' => {
      'allocated' => Integer
    },
    'networks' => [{
                     'name' => String,
                     'uri'  => String
                   }],
    'vms' => [{
                'name' => String,
                'uri'  => String
              }]
  }

  tests('success') do

    tests("#get_vdc").formats(@vdc_format) do
      vdc     = TerremarkEcloud::Compute.preferred_vdc
      vdc_uri = vdc['uri']

      TerremarkEcloud[:compute].get_vdc(vdc_uri).body
    end

  end

end
