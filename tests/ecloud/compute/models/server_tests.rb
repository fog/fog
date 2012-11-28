provider, config = :ecloud, compute_providers[:ecloud]

connection   = Fog::Compute[provider]
organization = connection.organizations.first
environment  = organization.environments.find{|e| e.name == config[:server_attributes][:environment_name]}
public_ip   = environment.public_ips.first
compute_pool = environment.compute_pools.first
image_href = Fog.credentials[:ecloud_image_href] || compute_pool.templates.first.href

Shindo.tests("Fog::Compute[:#{provider}] | servers", "operations") do
  @network = environment.networks.first
  options  = config[:server_attributes].merge(:network_uri => @network.href)
  if Fog.credentials[:ecloud_ssh_key_id]
    options = options.merge(:ssh_key_uri => "/cloudapi/ecloud/admin/sshkeys/#{Fog.credentials[:ecloud_ssh_key_id]}")
  end
  @server = compute_pool.servers.create(image_href, options)

  tests('#create_server').succeeds do
    @server.wait_for { ready? } # server
  end

  @hwc = @server.hardware_configuration
  tests('#add_disk_to_server').succeeds do
    disk_count = @hwc.storage.is_a?(Hash) ? [@hwc.storage].count : @hwc.storage.count
    @server.add_disk(25).wait_for { ready? }
    returns(true, "disk count increased by 1") { @server.reload.hardware_configuration.storage.count == disk_count + 1 }
  end

  tests('#detach_disk_from_server').succeeds do
    disk_count = @hwc.reload.storage.is_a?(Hash) ? [@hwc.storage].count : @hwc.storage.count
    @server.detach_disk(1).wait_for { ready? }
    returns(true, "disk count decreased by 1") { @server.reload.hardware_configuration.storage.count == disk_count - 1 }
  end

  @detached_disk = compute_pool.reload.detached_disks.detect { |d| d.name == @server.name }
  tests('#attach_disk_to_server').succeeds do
    disk_count = @hwc.reload.storage.is_a?(Hash) ? [@hwc.storage].count : @hwc.storage.count
    @server.attach_disk(@detached_disk).wait_for { ready? }
    returns(true, "disk count increased by 1") { @server.reload.hardware_configuration.storage.count == disk_count + 1 }
  end

  tests('#delete_disk').succeeds do
    disk_count = @hwc.reload.storage.is_a?(Hash) ? [@hwc.storage].count : @hwc.storage.count
    @server.delete_disk(1).wait_for { ready? }
    returns(true, "disk count decreased by 1") { @server.reload.hardware_configuration.storage.count == disk_count - 1 }
  end

  @ip = @network.ips.reload.detect { |i| i.host.nil? && i.detected_on.nil? }
  tests('#add_ip_to_server').succeeds do
    @server.add_ip(:href => @network.href, :network_name => @network.name, :ip => @ip.name)
  end

  service_name     = Fog.credentials[:ecloud_internet_service_name] || Fog::Mock.random_letters(6)
  service_port     = Fog.credentials[:ecloud_internet_service_port] || Fog::Mock.random_numbers(3).to_i
  service_protocol = Fog.credentials[:ecloud_internet_service_protocol]
  @service = public_ip.internet_services.create(:name => service_name, :port => service_port, :protocol => service_protocol, :description => "", :enabled => true)

  tests('#create_internet_service').succeeds do
    @service.wait_for { ready? }
    returns(true, "is an internet service") { @service.is_a?(Fog::Compute::Ecloud::InternetService) }
  end

  unless @server.ips.empty?
    @ip_address = @server.ips.first
    @ip         = @server.ips.first.network.ips.detect { |i| i.name == @ip_address.address.name }
    @node       = @service.nodes.create(:name => @server.name, :port => service_port, :ip_address => @ip.href, :description => "", :enabled => true)
    tests('#create_node_service').succeeds do
      @node.wait_for { ready? }
      returns(true, "is a node server") { @node.is_a?(Fog::Compute::Ecloud::Node) }
    end

    tests('#destroy_node_service').succeeds do
      @node.destroy.wait_for { ready? }
    end
  end

  #tests('#delete_ip_from_server').succeeds do
  #  @server.delete_ip(:href => @network.href, :network_name => @network.name, :ip => @ip.name)
  #end

  tests('#destroy_internet_service').succeeds do
    @service.destroy.wait_for { ready? }
  end

  tests('#destroy_server').succeeds do
    @server.destroy.wait_for { ready? } # task
  end
end

Shindo.tests("Fog::Compute[:#{provider}] | server", "attributes") do
  @network = environment.networks.first
  options = config[:server_attributes].merge(:network_uri => @network.href)
  if Fog.credentials[:ecloud_ssh_key_id]
    options = options.merge(:ssh_key_uri => "/cloudapi/ecloud/admin/sshkeys/#{Fog.credentials[:ecloud_ssh_key_id]}")
  end

  @server = compute_pool.servers.first || compute_pool.servers.create(image_href, options).tap{|s| s.wait_for { ready? }}

  tests('#ip_addresses').succeeds do
    returns(true, "is an array") { @server.ips.is_a?(Array) }
    returns(true, "contains an VirtualMachineAssignedIp") { @server.ips.all?{|ip| ip.is_a?(Fog::Compute::Ecloud::VirtualMachineAssignedIp) } }
  end
end
