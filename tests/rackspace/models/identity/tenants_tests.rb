Shindo.tests('Fog::Rackspace::Identity | tenants', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Identity.new
  username = "fog_user_#{Time.now.to_i.to_s}"
  options = {
    :username => username,
    :email => 'email@example.com',
    :enabled => true
  }

  tests("#all").succeeds do
    service.tenants.all
  end

  tests("#get").succeeds do
    tenant = service.tenants.all.first
    service.tenants.get(tenant.identity)
  end
end
