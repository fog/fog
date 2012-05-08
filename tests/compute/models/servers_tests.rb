
for provider, config in compute_providers
  next if ENV['FOG_PROVIDER'] && provider.to_s != ENV['FOG_PROVIDER']

  Shindo.tests("Fog::Compute[:#{provider}] | servers", [provider.to_s]) do

    servers_tests(Fog::Compute[provider], (config[:server_attributes] || {}), config[:mocked])

  end

end
