for provider, config in compute_providers
  Shindo.tests("Fog::Compute[:#{provider}] | server", [provider.to_s]) do

    provider_attributes = config[:provider_attributes] || {}
    provider_attributes.merge!(:provider => provider)
    server_tests(Fog::Compute.new(provider_attributes), (config[:server_attributes] || {}), config[:mocked]) do

      if Fog.mocking? && !config[:mocked]
        pending
      else
        responds_to(:public_ip_address)
        responds_to(:scp)
        responds_to(:ssh)
      end

      tests('ssh_ip_address') do
        tests('defaults to public_ip_address').returns(true) do
          @instance.ssh_ip_address == @instance.public_ip_address
        end
        tests('ssh_ip_address overrides default with Proc').returns(true) do
          ip_address = '5.5.5.5'
          @instance.ssh_ip_address = Proc.new {|server| ip_address }
          @instance.ssh_ip_address == ip_address
        end
        tests('Proc yields server').returns(true) do
          @instance.ssh_ip_address = Proc.new {|server| server }
          @instance.ssh_ip_address == @instance
        end
        tests('ssh_ip_address overrides default with String').returns(true) do
          ip_address = '5.5.5.5'
          @instance.ssh_ip_address = ip_address
          @instance.ssh_ip_address == ip_address
        end
      end

    end

  end
end
