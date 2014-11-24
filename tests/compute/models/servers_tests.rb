for provider, config in compute_providers
  Shindo.tests("Fog::Compute[:#{provider}] | servers", [provider.to_s]) do

    provider_attributes = config[:provider_attributes] || {}
    provider_attributes.merge!(:provider => provider)
    servers_tests(Fog::Compute.new(provider_attributes), (config[:server_attributes] || {}), config[:mocked])

  end

end
