provider, config = :cloudstack, compute_providers[:cloudstack]

Shindo.tests("Fog::Compute[:#{provider}] | servers + security_groups", [provider.to_s]) do
  connection = Fog::Compute[provider]
  @security_group = connection.security_groups.create(config[:security_group_attributes])
  @server = connection.servers.create(config[:server_attributes].merge(:security_groups => [@security_group]))

  tests('#security_group').succeeds do
    @server.wait_for { ready? }
    @server.security_groups.map(&:id) == [@security_group.id]
  end

  tests('#destroy').succeeds do
    @server.destroy.wait_for { ready? }
    @security_group.destroy
  end

end
