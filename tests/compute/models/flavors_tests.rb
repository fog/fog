for provider, config in compute_providers

  next if [:glesys, :ibm].include?(provider)

  Shindo.tests("Fog::Compute[:#{provider}] | flavors", [provider.to_s]) do

    provider_attributes = config[:provider_attributes] || {}
    provider_attributes.merge!(:provider => provider)
    flavors_tests(Fog::Compute.new(provider_attributes), (config[:flavors_attributes] || {}), config[:mocked])

  end

end
