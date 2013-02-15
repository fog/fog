provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | ip_addresses", [provider.to_s]) do
  connection = Fog::Compute[provider]
  @organization = connection.organizations.first
  @environment = @organization.environments.first
  @network = @environment.networks.first
  @ip_addresses = @network.ips

  tests('#all').succeeds do
    returns(false) { @ip_addresses.all.empty? }
  end

  tests('#get').succeeds do
    address = @ip_addresses.first
    fetched_network = connection.ip_addresses.get(address.href)
    returns(false) { fetched_network.nil? }
  end
end
