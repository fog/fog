require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

Shindo.tests("Compute::VcloudDirector | networks", ['vclouddirector', 'all']) do

  # unless there is at least one network we cannot run these tests
  pending if organization.networks.empty?

  service = Fog::Compute::VcloudDirector.new

  networks = organization.networks
  network_raw = nil

  # Run initial tests against a natRouted network, since these
  # are more likely to be created, and must be populated with
  # Gateway and EdgeGateway sections
  network = networks.find do |net|
    network_raw = service.get_network_complete(net.id).body
    network_raw[:Configuration][:FenceMode] == 'natRouted'
  end

  # We don't have a sufficiently populated natRouted network to test against
  pending if network_raw.nil?

  UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
  IP_REGEX = /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/

  tests("Compute::VcloudDirector | network") do
    tests("#id").returns(0) { network.id =~ UUID_REGEX }
    tests("#name").returns(String) { network.name.class }
    tests("#href").returns(String) { network.href.class }
    tests("#type").returns("application/vnd.vmware.vcloud.orgNetwork+xml"){ network.type }
  end

  tests("Compute::VcloudDirector | network", ['lazy load attrs']) do
    network.lazy_load_attrs.each do |lazy_attr|
      tests("##{lazy_attr} is not loaded yet").returns(NonLoaded) { network.attributes[lazy_attr] }
    end
  end

  tests("Compute::VcloudDirector | network", ['load on demand']) do
    network_raw_gateway = network_raw[:Configuration][:IpScopes][:IpScope][:Gateway]
    tests("#gateway is not loaded yet").returns(NonLoaded) { network.attributes[:gateway] }
    tests("#gateway is loaded on demand").returns(network_raw_gateway) { network.gateway }
    tests("#gateway is now loaded").returns(true) { network.attributes[:gateway] != NonLoaded }
  end

  tests("Compute::VcloudDirector | network", ['all lazy load attrs should now be loaded with data']) do
    network.lazy_load_attrs.each do |field|
      tests("##{field.to_s} is now loaded").returns(true) { network.attributes[field] != NonLoaded }
    end
  end

  tests("Compute::VcloudDirector | network", ['ip_ranges is an array of start-end pairs']) do
    tests("#ip_ranges is an Array").returns(Array) { network.ip_ranges.class }
    network.ip_ranges.each do |range|
      tests("each ip_range has a :start_address").returns(0) { range[:start_address] =~ IP_REGEX }
      tests("each ip_range has an :end_address").returns(0) { range[:end_address] =~ IP_REGEX }
    end
  end

  tests("Compute::VcloudDirector | network", ['is_shared is a string boolean']) do
    tests("#is_shared is either 'true' or 'false'").returns(true) {
      [ 'false', 'true' ].include?(network.is_shared)
    }
  end

  # NB: get_by_name is buggy with orgVdcNetworks - network names are only
  # unique per-vDC, not per organization.
  # As a result, it returns the *first* network matching that name.
  tests("Compute::VcloudDirector | networks", ['get']) do
    tests("#get_by_name").returns(network.name) { networks.get_by_name(network.name).name }
    tests("#get").returns(network.id) { networks.get(network.id).id }
  end


  # Now let's also check against an isolated network, since these have some
  # additional features like DHCP ServiceConfigurations.
  isolated_network_raw = nil
  isolated_network = networks.find do |net|
    isolated_network_raw = service.get_network_complete(net.id).body
    isolated_network_raw[:Configuration][:FenceMode] == 'isolated'
  end

  pending if isolated_network_raw.nil?

  tests("Compute::VcloudDirector | isolated network", ['load on demand']) do
    tests("#fence_mode is not loaded yet").returns(NonLoaded) { isolated_network.attributes[:fence_mode] }
    tests("#fence_mode is loaded on demand").returns('isolated') { isolated_network.fence_mode }
    tests("#fence_mode is now loaded").returns(true) { isolated_network.attributes[:fence_mode] != NonLoaded }
  end

  # We should also be able to find these same networks via Query API
  tests("Compute::VcloudDirector | networks", ['find_by_query']) do
    tests('we can retrieve :name without lazy loading').returns(network.name) do
      query_network = networks.find_by_query(:filter => "name==#{network.name}").first
      query_network.attributes[:name]
    end
    tests('by name: natRouted').returns(network.name) do
      query_network = networks.find_by_query(:filter => "name==#{network.name}").first
      query_network.name
    end
    tests('by name: isolated').returns(isolated_network.name) do
      query_network = networks.find_by_query(:filter => "name==#{isolated_network.name}").first
      query_network.name
    end
  end

end
