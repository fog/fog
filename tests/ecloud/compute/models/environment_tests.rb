provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | environments", [provider.to_s]) do
  connection = Fog::Compute[provider]
  @organization = connection.organizations.first

  tests('#all').succeeds do
    returns(false) { @organization.environments.all.empty? }
  end

  tests('#get').succeeds do
    environment         = @organization.environments.all.first
    fetched_environment = connection.environments.get(environment.href)

    returns(true) { !fetched_environment.nil? }
  end

  tests("#organization").succeeds do
    environment = @organization.environments.all.first
    returns(false, "returns an organization") { environment.organization.nil? }
    returns(true, "returns correct organization") { environment.organization.href == @organization.href }
  end
end
