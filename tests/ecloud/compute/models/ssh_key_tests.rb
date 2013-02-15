provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | ssh_keys", [provider.to_s]) do
  connection = Fog::Compute[provider]
  @organization = connection.organizations.first
  @admin_organization = @organization.admin
  @admin_organization.reload
  @ssh_keys = @admin_organization.ssh_keys

  tests('#all').succeeds do
    returns(false) { @ssh_keys.empty? }
  end

  tests('#get').succeeds do
    ssh_key = @ssh_keys.first

    returns(false) { @ssh_keys.get(ssh_key.href).nil? }
  end
end
