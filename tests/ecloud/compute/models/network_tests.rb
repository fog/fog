provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | networks", [provider.to_s]) do
  connection = Fog::Compute[provider]
  @organization = connection.organizations.first
  @environment = @organization.environments.first

  tests('#all').succeeds do
    returns(false) { @environment.networks.all.empty? }
  end

  tests('#get').succeeds do
    network = @environment.networks.all.first
    fetched_network = connection.networks.get(network.href)
    returns(true) { !fetched_network.nil? }
  end
end
