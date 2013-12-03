provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | compute_pools", [provider.to_s]) do
  connection = Fog::Compute[provider]
  @organization = connection.organizations.first
  @environment = @organization.environments.first

  tests('#all').succeeds do
    returns(false) { @environment.compute_pools.all.empty? }
  end

  tests('#get').succeeds do
    compute_pool = @environment.compute_pools.all.first
    fetched_compute_pool = connection.compute_pools.get(compute_pool.href)
    returns(true) { !fetched_compute_pool.nil? }
  end
end
