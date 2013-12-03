provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | operating_system", [provider.to_s]) do
  connection = Fog::Compute[provider]
  @organization = connection.organizations.first
  @environment  = @organization.environments.find{|e| e.name == config[:server_attributes][:environment_name]} || @organization.environments.first
  @compute_pool = @environment.compute_pools.first

  tests('#all').succeeds do
    family            = @compute_pool.operating_system_families.first
    operating_systems = family.operating_systems

    returns(false) { operating_systems.empty? }
  end

  tests('#get').succeeds do
    family           = @compute_pool.operating_system_families.first
    operating_system = family.operating_systems.first

    returns(false) { family.operating_systems.get(operating_system.href).nil? }
  end
end
