
for provider, config in compute_providers

  Shindo.tests("Fog::Compute[:#{provider}] | volumes", [provider.to_s]) do

    volumes_tests(Fog::Compute[provider], (config[:volume_attributes] || {}), config[:mocked])

  end

end
