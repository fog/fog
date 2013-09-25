provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | admin_organizations", [provider.to_s]) do
  connection = Fog::Compute[provider]
  @organization = connection.organizations.first
  @admin_organization = @organization.admin

  tests('#get').succeeds do
    fetched_admin_organization = connection.get_admin_organization(@admin_organization.href)
    returns(true) { !fetched_admin_organization.nil? }
  end

  tests('#ssh_keys').succeeds do
    returns(true, "a list of SshKeys") { @admin_organization.ssh_keys.is_a?(Fog::Compute::Ecloud::SshKeys) }
  end
end
