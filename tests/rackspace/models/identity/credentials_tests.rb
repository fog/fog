Shindo.tests('Fog::Rackspace::Identity | credentials', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Identity.new
  user = service.users.all.first

  tests('success') do
    tests("#all").succeeds do
      credentials = user.credentials.all
      credentials.all? { |c| c.username && c.apiKey }
    end

    tests("#get").succeeds do
      list_credential = user.credentials.all.first

      credential = user.credentials.get(list_credential.identity)
      credential.username && credential.apiKey
    end
  end

  tests("failure").returns(nil) do
    user.credentials.get('i am a credential that does not exist')
  end
end
