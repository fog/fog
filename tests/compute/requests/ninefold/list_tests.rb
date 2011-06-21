Shindo.tests('Fog::Compute[:ninefold] | list only requests', ['ninefold']) do

  tests('success') do

    tests("#list_accounts()").formats(Ninefold::Compute::Formats::Lists::ACCOUNTS) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].list_accounts
    end

    tests("#list_events()").formats(Ninefold::Compute::Formats::Lists::EVENTS) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].list_events
    end

    tests("#list_service_offerings()").formats(Ninefold::Compute::Formats::Lists::SERVICE_OFFERINGS) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].list_service_offerings
    end

    tests("#list_disk_offerings()").formats(Ninefold::Compute::Formats::Lists::DISK_OFFERINGS) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].list_disk_offerings
    end

    tests("#list_capabilities()").formats(Ninefold::Compute::Formats::Lists::CAPABILITIES) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].list_capabilities
    end

    tests("#list_hypervisors()").formats(Ninefold::Compute::Formats::Lists::HYPERVISORS) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].list_hypervisors
    end

    tests("#list_zones()").formats(Ninefold::Compute::Formats::Lists::ZONES) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].list_zones
    end

    tests("#list_network_offerings()").formats(Ninefold::Compute::Formats::Lists::NETWORK_OFFERINGS) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].list_network_offerings
    end

    tests("#list_resource_limits()").formats(Ninefold::Compute::Formats::Lists::RESOURCE_LIMITS) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].list_resource_limits
    end

  end

  tests('failure') do

  end

end
