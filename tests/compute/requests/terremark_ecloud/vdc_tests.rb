Shindo.tests('TerremarkEcloud::Compute | vdc requests', ['terremark_ecloud']) do

  @vdc_format = {
    'AvailableNetworks' => [{
      'href' => String,
      'name' => String,
      'type' => String
    }],
    'ComputeCapacity' => {
      'Cpu' => {
        'Allocated' => Integer,
        'Units'     => String
      },
      'DeployedVmsQuota' => {
        'Limit' => Integer,
        'Used'  => Integer
      },
      'InstantiatedVmsQuota' => {
        'Limit' => Integer,
        'Used'  => Integer
      },
      'Memory' => {
        'Allocated' => Integer,
        'Units'     => String
      }
    },
    'Description' => Fog::Nullable::String,
    'href' => String,
    'Link' => [{
      'href' => String,
      'name' => String,
      'rel'  => String,
      'type' => String
    }],
    'name' => String,
    'ResourceEntities' => [{
      'href' => String,
      'name' => String,
      'type' => String
    }],
    'StorageCapacity' => {
      'Allocated' => Integer,
      'Units'     => String,
      'Used'      => Integer
    }
  }

  tests('success') do

    tests("#get_vdc").formats(@vdc_format) do
      vdc     = TerremarkEcloud::Compute.preferred_vdc
      vdc_href = vdc['href']

      TerremarkEcloud[:compute].get_vdc(vdc_href).body
    end

  end

end
