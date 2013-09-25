provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | operating_system_families", [provider.to_s]) do
  connection = Fog::Compute[provider]
  @organization = connection.organizations.first
  @environment  = @organization.environments.find{|e| e.name == config[:server_attributes][:environment_name]} || @organization.environments.first
  @compute_pool = @environment.compute_pools.first

  tests('#all').succeeds do
    operating_system_families = @compute_pool.operating_system_families
    returns(false) { operating_system_families.empty? }
  end
end
