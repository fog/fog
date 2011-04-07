for provider, config in compute_providers

  Shindo.tests("#{provider}::Compute | server", [provider.to_s.downcase]) do

    server_tests(provider[:compute], (config[:server_attributes] || {}), config[:mocked]) do

      if Fog.mocking? && !config[:mocked]
        pending
      else
        responds_to(:boostrap)
        responds_to(:public_ip_address)
        responds_to(:scp)
        responds_to(:ssh)
        responds_to(:lb_applications)
      end

    end

  end

end
