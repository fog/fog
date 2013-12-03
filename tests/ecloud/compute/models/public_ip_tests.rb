provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | ip_addresses", [provider.to_s]) do
  connection = Fog::Compute[provider]
  @organization = connection.organizations.first
  @environment = @organization.environments.first
  @public_ips = @environment.public_ips

  tests('#all').succeeds do
    returns(false, "has ips") { @public_ips.all.empty? }
  end

  tests('#get').succeeds do
    address = @public_ips.first
    fetched_ip = connection.public_ips.get(address.href)
    returns(false, "ip is not nil") { fetched_ip.nil? }
    returns(true, "is a PublicIp") { fetched_ip.is_a?(Fog::Compute::Ecloud::PublicIp) }
  end
end
