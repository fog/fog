for provider, config in compute_providers

  next if [:glesys, :voxel, :ibm].include?(provider)

  Shindo.tests("Fog::Compute[:#{provider}] | flavors", [provider]) do

    flavors_tests(Fog::Compute[provider], (config[:flavors_attributes] || {}), config[:mocked])

  end

end
