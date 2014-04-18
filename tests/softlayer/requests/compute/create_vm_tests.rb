Shindo.tests("Fog::Compute[:softlayer] | server requests", ["softlayer"]) do

  @sl_connection = Fog::Compute[:softlayer]
  @vms = [{
              "hostname" => "host1",
              "domain" => "example.com",
              "startCpus" => 1,
              "maxMemory" => 1024,
              "hourlyBillingFlag" => true,
              "localDiskFlag" => true,
              "operatingSystemReferenceCode" => "UBUNTU_LATEST"
          },
          {
              "hostname" => "host2",
              "domain" => "example.com",
              "startCpus" => 1,
              "maxMemory" => 1024,
              "hourlyBillingFlag" => true,
              "localDiskFlag" => true,
              "operatingSystemReferenceCode" => "UBUNTU_LATEST"
          }
  ]
  @vm = @vms.first

  tests('success') do

    tests("#create_vms('#{@vms}')") do
      response = @sl_connection.create_vms(@vms)
      data_matches_schema([Softlayer::Compute::Formats::VirtualGuest::SERVER], {:allow_extra_keys => true}) { response.body }
      data_matches_schema(200) { response.status }
    end

    tests("#create_vm('#{@vm}')") do
      response = @sl_connection.create_vm(@vm)
      data_matches_schema([Softlayer::Compute::Formats::VirtualGuest::SERVER], {:allow_extra_keys => true}) { response.body }
      data_matches_schema(200) { response.status }
    end
  end

  tests('failure') do
    vms = @vms.dup; vms.first.delete('hostname')
    tests("#create_vms('#{vms}')") do
      response = @sl_connection.create_vms(vms)
      data_matches_schema('SoftLayer_Exception_MissingCreationProperty'){ response.body['code'] }
      data_matches_schema(500){ response.status }
    end

    vm = @vm.dup; vm.delete('domain')
    tests("#create_vm('#{vm}')") do
      response = @sl_connection.create_vm(vm)
      data_matches_schema('SoftLayer_Exception_MissingCreationProperty'){ response.body['code'] }
      data_matches_schema(500){ response.status }
    end

    tests("#create_vms(#{@vm}").raises(ArgumentError) do
      @sl_connection.create_vms(@vm)
    end

    tests("#create_vm(#{@vms}").raises(ArgumentError) do
      @sl_connection.create_vm(@vms)
    end

  end
end
