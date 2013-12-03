provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | organizations", [provider.to_s]) do
  connection = Fog::Compute[provider]

  tests('#all').succeeds do
    returns(false) { connection.organizations.all.empty? }
  end

  tests('#get').succeeds do
    organization = connection.organizations.all.first
    fetched_organization = connection.organizations.get(organization.href)
    returns(true) { !fetched_organization.nil? }
  end

  tests("#admin").succeeds do
    organization = connection.organizations.all.first

    returns(true, "return AdminOrganization") { organization.admin.is_a?(Fog::Compute::Ecloud::AdminOrganization) }
  end
end
