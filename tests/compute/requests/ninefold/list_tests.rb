Shindo.tests('Ninfold::Compute | list only requests', ['ninefold']) do

  tests('success') do

    tests("#list_accounts()").formats(Ninefold::Compute::Formats::Lists::ACCOUNTS) do
      pending if Fog.mocking?
      Ninefold[:compute].list_accounts
    end

    tests("#list_events()").formats(Ninefold::Compute::Formats::Lists::EVENTS) do
      pending if Fog.mocking?
      Ninefold[:compute].list_events
    end

    tests("#list_service_offerings()").formats(Ninefold::Compute::Formats::Lists::SERVICE_OFFERINGS) do
      pending if Fog.mocking?
      Ninefold[:compute].list_service_offerings
    end

    tests("#list_disk_offerings()").formats(Ninefold::Compute::Formats::Lists::DISK_OFFERINGS) do
      pending if Fog.mocking?
      Ninefold[:compute].list_disk_offerings
    end

    tests("#list_capabilities()").formats(Ninefold::Compute::Formats::Lists::CAPABILITIES) do
      pending if Fog.mocking?
      Ninefold[:compute].list_capabilities
    end

    tests("#list_hypervisors()").formats(Ninefold::Compute::Formats::Lists::HYPERVISORS) do
      pending if Fog.mocking?
      Ninefold[:compute].list_hypervisors
    end

    tests("#list_zones()").formats(Ninefold::Compute::Formats::Lists::ZONES) do
      pending if Fog.mocking?
      Ninefold[:compute].list_zones
    end

    tests("#list_network_offerings()").formats(Ninefold::Compute::Formats::Lists::NETWORK_OFFERINGS) do
      pending if Fog.mocking?
      Ninefold[:compute].list_network_offerings
    end

    tests("#list_resource_limits()").formats(Ninefold::Compute::Formats::Lists::RESOURCE_LIMITS) do
      pending if Fog.mocking?
      Ninefold[:compute].list_resource_limits
    end

  end

  tests('failure') do

  end

end
