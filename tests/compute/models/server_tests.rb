for provider, config in compute_providers

  Shindo.tests("#{provider}::Compute | server", [provider.to_s.downcase]) do

    server_tests(provider[:compute], (config[:server_attributes] || {}), config[:mocked]) do

      tests('responds_to(:bootstrap)') do
        pending if Fog.mocking? && !config[:mocked]
        @instance.responds_to(:bootstrap)
      end

      tests('responds_to(:private_ip_address)') do
        pending if Fog.mocking? && !config[:mocked]
        @instance.responds_to(:public_ip_address)
      end

      tests('responds_to(:public_ip_address)') do
        pending if Fog.mocking? && !config[:mocked]
        @instance.responds_to(:public_ip_address)
      end

      tests('responds_to(:scp)') do
        pending if Fog.mocking? && !config[:mocked]
        @instance.responds_to(:ssh)
      end

      tests('responds_to(:ssh)') do
        pending if Fog.mocking? && !config[:mocked]
        @instance.responds_to(:ssh)
      end

    end

  end

end
