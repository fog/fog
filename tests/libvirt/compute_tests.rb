Shindo.tests('Fog::Compute[:libvirt]', ['libvirt']) do

  compute = Fog::Compute[:libvirt]

  tests("Compute collections") do
    %w{ servers interfaces networks nics nodes pools volumes}.each do |collection|
      test("it should respond to #{collection}") { compute.respond_to? collection }
    end
  end

  tests("Compute requests") do
    %w{ create_domain create_volume define_domain define_pool destroy_interface destroy_network get_node_info list_domains
        list_interfaces list_networks list_pools list_pool_volumes list_volumes pool_action vm_action volume_action }.each do |request|
      test("it should respond to #{request}") { compute.respond_to? request }
    end
  end
end
