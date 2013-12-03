provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | templates", [provider.to_s]) do
  connection = Fog::Compute[provider]
  @organization = connection.organizations.first
  @environment  = @organization.environments.find{|e| e.name == config[:server_attributes][:environment_name]} || @organization.environments.first
  @compute_pool = @environment.compute_pools.first

  tests('#all').succeeds do
    templates = @compute_pool.templates
    returns(false) { templates.empty? }
  end

  tests('#get').succeeds do
    templates = @compute_pool.templates
    template = templates.first

    returns(false) { @compute_pool.templates.get(template.href).nil? }
  end
end
