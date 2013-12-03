Shindo.tests('Fog::Rackspace::Identity | users', ['rackspace']) do

  pending if Fog.mock?

  USER_INFO = {
    'id' => String,
    'username' => String,
    'email' => Fog::Nullable::String,
    'enabled' => Fog::Boolean,
    'OS-KSADM:password' => Fog::Nullable::String,
    'created' => Fog::Nullable::String,
    'updated' => Fog::Nullable::String
  }

  USER_FORMAT = {
    'user' => USER_INFO
  }

  USERS_FORMAT = {
    'users' => [USER_INFO]
  }

  CREDENTIAL_FORMAT = {
    'RAX-KSKEY:apiKeyCredentials' => {
      'username' => String,
      'apiKey' => String
    }
  }

  CREDENTIALS_FORMAT = {
    'credentials' => [CREDENTIAL_FORMAT]
  }

  ROLES_FORMAT = {
    'roles' => [{
      'id' => String,
      'name' => String,
      'description' => String
    }]
  }

  service = Fog::Rackspace::Identity.new
  id = nil
  username = "fog#{Time.now.to_i.to_s}"
  email = 'fog_user@example.com'
  enabled = true
  password = 'Fog_password1'

  tests('success') do
    tests('#create_user').formats(USER_FORMAT) do
      data = service.create_user(username, email, enabled).body
      id = data['user']['id']
      data
    end

    tests('#delete_user').succeeds do
      service.delete_user(id)
    end

    # there appears to be a werid caching issue. It's just easier to create a new username and continue on
    username = "fog#{Time.now.to_i.to_s}"

    tests('#create_user with password').succeeds do
      data = service.create_user(username, email, enabled, :password => password ).body
      id = data['user']['id']
      data
    end

    tests('#get_user_by_name').formats(USER_FORMAT) do
      data = service.get_user_by_name(username).body
      id = data['user']['id']
      data
    end

    tests('#get_user_by_id').formats(USER_FORMAT) do
      service.get_user_by_id(id).body
    end

    tests('#list_users').formats(USERS_FORMAT) do
      service.list_users().body
    end

    tests('#update_user').formats(USER_FORMAT) do
      service.update_user(id, username, 'updated_user@example.com', enabled).body
    end

    tests('#update_user with password').succeeds do
      service.update_user(id, username, email, enabled, :password => password).body
    end

    tests('#list_user_roles').formats(ROLES_FORMAT) do
      service.list_user_roles(id).body
    end

    service.delete_user(id)

    # Users are only authorized to request their own credentials,
    # so perform credential tests with the ID of the user running tests.
    credential_username = Fog.credentials[:rackspace_username]
    credential_id = service.get_user_by_name(credential_username).body['user']['id']

    tests('#list_credentials').formats(CREDENTIALS_FORMAT) do
      service.list_credentials(credential_id).body
    end
  end
end
