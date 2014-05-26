provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | servers", [provider.to_s, "operations"]) do
  connection   = Fog::Compute[provider]
  connection.base_path = '/cloudapi/spec'
  config[:server_attributes][:organization_uri] ? organization = connection.organizations.get("#{connection.base_path}#{config[:server_attributes][:organization_uri]}") : organization = connection.organizations.first
  environment  = organization.environments.find{|e| e.name == config[:server_attributes][:environment_name]} || organization.environments.first
  public_ip    = environment.public_ips.first
  compute_pool = environment.compute_pools.first
  image_href   = Fog.credentials[:ecloud_image_href] || compute_pool.templates.first.href
  ssh_key      = organization.admin.ssh_keys.find { |key| key.name == "root" } || organization.admin.ssh_keys.first

  @network = environment.networks.first
  options  = config[:server_attributes].merge(:network_uri => @network.href, :ssh_key_uri => ssh_key.href)
  #if Fog.credentials[:ecloud_ssh_key_id]
  #  options = options.merge(:ssh_key_uri => "/cloudapi/ecloud/admin/sshkeys/#{Fog.credentials[:ecloud_ssh_key_id]}")
  #end

  tests('#create_server').succeeds do
    compute_pool.servers.create(image_href, options)
  end

  # Use the Living Specification, VM2 has valid power state to delete disks
  vm_uri = "#{connection.base_path}/virtualMachines/2"
  @server = compute_pool.servers.get(vm_uri)

  tests('#environment_has_a_row_and_group_with_the_right_names').succeeds do
    row = environment.rows.find { |r| r.name == options[:row] }
    returns(false, "row is not nil") { row.nil? }
    group = row.groups.find { |g| g.name == options[:group] }
    returns(false, "group is not nil") { group.nil? }
    server = group.servers.find { |s| s.name == options[:name] }
    returns(false, "group has server") { server.nil? }
  end

  tests('#get_server_flavor').succeeds do
    @server.flavor_id == {:ram => 1024, :cpus => 2}
  end

  @hwc = @server.hardware_configuration
  tests('#add_disk_to_server').succeeds do
    @server.add_disk(25)
  end

  tests('#detach_disk_from_server').succeeds do
    server = connection.servers.get("#{connection.base_path}/virtualMachines/1")
    server.detach_disk(1)
  end

  @detached_disk = compute_pool.reload.detached_disks.first
  tests('#attach_disk_to_server').succeeds do
    server = connection.servers.get("#{connection.base_path}/virtualMachines/1")
    server.attach_disk(@detached_disk)
  end

  tests('#delete_disk').succeeds do
    @server.delete_disk(1)
  end

  @ip = @network.ips.reload.find { |i| i.host.nil? && i.detected_on.nil? }
  tests('#add_ip_to_server').succeeds do
    @server.add_ip(:href => @network.href, :network_name => @network.name, :ip => @ip.name)
  end

  service_name     = Fog.credentials[:ecloud_internet_service_name] || Fog::Mock.random_letters(6)
  service_port     = Fog.credentials[:ecloud_internet_service_port] || Fog::Mock.random_numbers(3).to_i
  service_protocol = Fog.credentials[:ecloud_internet_service_protocol]

  tests('#create_internet_service').succeeds do
    @service = public_ip.internet_services.create(:name => service_name, :port => service_port, :protocol => service_protocol, :description => "", :enabled => true)
    returns(true, "is an internet service") { @service.is_a?(Fog::Compute::Ecloud::InternetService) }
  end

  @service = public_ip.internet_services.first

  @ip_address = @server.ips.first
  @ip         = @server.ips.first.network.ips.find { |i| i.name == @ip_address.address.name }
  @node       = @service.nodes.create(:name => @server.name, :port => service_port, :ip_address => @ip.href, :description => "", :enabled => true)
  tests('#create_node_service').succeeds do
    returns(true, "is a node server") { @node.is_a?(Fog::Compute::Ecloud::Node) }
  end

  tests('#destroy_node_service').succeeds do
    @node.destroy
  end

  #tests('#delete_ip_from_server').succeeds do
  #  @server.delete_ip(:href => @network.href, :network_name => @network.name, :ip => @ip.name)
  #end

  # NOTE(xtoddx): the Living Specification doesn't have any empty services
  #tests('#destroy_internet_service').succeeds do
  #  @service.destroy
  #end

  @server_count = environment.servers.count
  tests('#destroy_server').succeeds do
    @server.destroy
  end
  @new_server_count = environment.servers.reload.count

  tests('#server_count_reduced').succeeds do
    returns(true, "server count is reduced") { @new_server_count < @server_count }
  end

  @row = environment.rows.find { |r| r.name == options[:row] }
  @group = @row.groups.find { |g| g.name == options[:group] }
  if @group.servers.empty?
    tests('#delete_group').succeeds do
      @group.destroy
      returns(true, "group no longer exists") { @group.reload.nil? }
    end
  end
  if @row.groups.reload.empty?
    tests("#delete_row").succeeds do
      @row.destroy
      returns(true, "row no longer exists") { @row.reload.nil? }
    end
  end
end

Shindo.tests("Fog::Compute[:#{provider}] | server", [provider.to_s, "attributes"]) do
  connection   = Fog::Compute[provider]
  connection.base_path = '/cloudapi/spec'
  organization = connection.organizations.first
  environment  = organization.environments.find{|e| e.name == config[:server_attributes][:environment_name]} || organization.environments.first
  public_ip    = environment.public_ips.first
  compute_pool = environment.compute_pools.first
  image_href   = Fog.credentials[:ecloud_image_href] || compute_pool.templates.first.href
  ssh_key      = organization.admin.ssh_keys.find { |key| key.name == "root" }

  @network = environment.networks.first
  options = config[:server_attributes].merge(:network_uri => @network.href, :ssh_key_uri => ssh_key.href)
  #if Fog.credentials[:ecloud_ssh_key_id]
  #  options = options.merge(:ssh_key_uri => "/cloudapi/ecloud/admin/sshkeys/#{Fog.credentials[:ecloud_ssh_key_id]}")
  #end

  @server = compute_pool.servers.first || compute_pool.servers.create(image_href, options).tap{|s| s.wait_for { ready? }}

  tests('#ip_addresses').succeeds do
    returns(true, "is an array") { @server.ips.is_a?(Array) }
    returns(true, "contains an VirtualMachineAssignedIp") { @server.ips.all?{|ip| ip.is_a?(Fog::Compute::Ecloud::VirtualMachineAssignedIp) } }
  end
end
