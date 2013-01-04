for provider, config in compute_providers

  next if [:ecloud].include?(provider)

  Shindo.tests("Fog::Compute[:#{provider}] | server", [provider.to_s]) do

    provider_attributes = config[:provider_attributes] || {}
    provider_attributes.merge!(:provider => provider)
    server_tests(Fog::Compute.new(provider_attributes), (config[:server_attributes] || {}), config[:mocked]) do

      if Fog.mocking? && !config[:mocked]
        pending
      else
        responds_to(:boostrap)
        responds_to(:public_ip_address)
        responds_to(:scp)
        responds_to(:ssh)
      end

    end

  end

end
