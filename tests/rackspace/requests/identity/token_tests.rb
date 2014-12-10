Shindo.tests('Fog::Rackspace::Identity | tokens', ['rackspace']) do
  ROLE_FORMAT = {
    'id' => String,
    'name' => String,
    'description' => String
  }

  ENDPOINT_FORMAT = {
    'tenantId' => String,
    'publicURL' => Fog::Nullable::String,
    'internalURL' => Fog::Nullable::String,
    'region' => Fog::Nullable::String,
    'versionId' => Fog::Nullable::String,
    'versionInfo' => Fog::Nullable::String,
    'versionList' => Fog::Nullable::String
  }

  SERVICE_FORMAT = {
    'name' => String,
    'type' => String,
    'endpoints' => [ENDPOINT_FORMAT]
  }

  ACCESS_FORMAT = {
    'access' => {
      'token' => {
        'id' => String,
        'expires' => String,
        'tenant' => {
          'id' => String,
          'name' => String
        }
      },
      'user' => {
        'id' => String,
        'name' => String,
        'roles' => [ROLE_FORMAT]
      },
      'serviceCatalog' => [SERVICE_FORMAT]
    }
  }

  service = Fog::Rackspace::Identity.new

  tests('success') do
    credentials = Fog.credentials
    username = credentials[:rackspace_username]
    api_key = credentials[:rackspace_api_key]

    tests('#create_token').formats(ACCESS_FORMAT) do
      service.create_token(username, api_key).body
    end

    tests('uses connection options').returns(true) do
      pending if Fog.mocking?
      identity_service = Fog::Rackspace::Identity.new(:connection_options => { :ssl_verify_peer => true })

      connection = identity_service.instance_variable_get("@connection")
      excon = connection.instance_variable_get("@excon")
      data = excon.instance_variable_get("@data")
      data.key?(:ssl_verify_peer)
    end
  end

  tests('failure') do
    tests('#create_token(invalidname, invalidkey').raises(Excon::Errors::HTTPStatusError) do
      service.create_token('baduser', 'badkey')
    end
  end
end
