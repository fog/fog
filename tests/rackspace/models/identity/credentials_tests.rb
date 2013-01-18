Shindo.tests('Fog::Rackspace::Identity | credentials', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Identity.new
  user = service.users.all.first

  tests("#all").succeeds do
    user.credentials.all
  end

  tests("#get").succeeds do
    credential = user.credentials.all.first
    user.credentials.get(credential.identity)
  end
end
