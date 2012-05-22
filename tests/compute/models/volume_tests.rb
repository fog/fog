for provider, config in compute_providers

  Shindo.tests("Fog::Compute[:#{provider}] | volume", [provider.to_s]) do

    volume_tests(Fog::Compute[provider], config, config[:mocked]) do

      if Fog.mocking? && !config[:mocked]
        pending
      else
        responds_to(:ready?)
        responds_to(:flavor)
      end

    end

  end

end
