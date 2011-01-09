Shindo.tests('TerremarkEcloud::Compute | network requests', ['terremark_ecloud']) do

  @network_format = {
    'name' => String,
    'uri'  => String,
    'extensions_ips_uri' => String,
    'extensions_uri' => String,
    'features' => { 'FenceMode' => String },
    'configuration' => {
      'netmask' => String,
      'gateway' => String
    }
  }

  @network_extensions_format = {
    'name' => String,
    'uri'  => String,
    'friendlyName' => String,
    'type' => String,
    'rnatAddress' => String,
    'gatewayAddress' => String,
    'broadcastAddress' => String,
    'address' => String
  }

  tests('success') do

    tests("#get_network").formats(@network_format) do
      TerremarkEcloud[:compute].get_network(TerremarkEcloud::Compute.preferred_network['uri']).body
    end

    tests("#get_network_extensions").formats(@network_extensions_format) do
      network_extensions_uri = TerremarkEcloud::Compute.preferred_network['extensions_uri']
      TerremarkEcloud[:compute].get_network_extensions(network_extensions_uri).body
    end
  end

end
