for provider, config in compute_providers

  Shindo.tests("Fog::Compute[:#{provider}] | server", [provider]) do

    server_tests(Fog::Compute[provider], (config[:server_attributes] || {}), config[:mocked]) do

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
