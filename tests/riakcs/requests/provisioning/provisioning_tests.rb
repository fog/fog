Shindo.tests('RiakCS::Provisioning | provisioning requests', ['riakcs']) do

  current_timestamp = Time.now.to_i

  user_format = {
    'email'        => String,
    'display_name' => String,
    'name'         => String,
    'key_id'       => String,
    'key_secret'   => String,
    'id'           => String,
    'status'       => String,
  }

  tests('User creation') do

    tests('is successful').returns(String) do

      # Create a user.
      #
      email, name = "successful_user_creation_test_#{current_timestamp}@example.com", "Fog User"
      key_id      = Fog::RiakCS[:provisioning].create_user(email, name).body['key_id']
      key_id.class

    end

    tests('is successful anonymously').returns(String) do

      # Create a user.
      #
      email, name = "successful_anonymous_user_creation_test_#{current_timestamp}@example.com", "Fog User"
      key_id      = Fog::RiakCS[:provisioning].create_user(email, name, :anonymous => true).body['key_id']
      key_id.class

    end

    tests('fails if duplicate').raises(Fog::RiakCS::Provisioning::UserAlreadyExists) do
      2.times do
        email, name = "failed_duplicate_user_creation_test_#{current_timestamp}@example.com", "Fog User"
        key_id      = Fog::RiakCS[:provisioning].create_user(email, name).body['key_id']
      end
    end

    tests('fails if invalid email').raises(Fog::RiakCS::Provisioning::ServiceUnavailable) do
      email, name = "failed_duplicate_user_creation_test_#{current_timestamp}", "Fog User"
      key_id      = Fog::RiakCS[:provisioning].create_user(email, name).body['key_id']
    end

  end

  tests('User disable') do

    tests('is successful').returns(200) do

      # Create a user.
      #
      email, name = "successful_user_disable_test_#{current_timestamp}@example.com", "Fog User"
      key_id      = Fog::RiakCS[:provisioning].create_user(email, name).body['key_id']

      Fog::RiakCS[:provisioning].disable_user(key_id).status

    end

  end

  tests('User enable') do

    tests('is successful').returns(200) do

      # Create a user.
      #
      email, name = "successful_user_disable_enable_test_#{current_timestamp}@example.com", "Fog User"
      key_id      = Fog::RiakCS[:provisioning].create_user(email, name).body['key_id']

      Fog::RiakCS[:provisioning].disable_user(key_id).status
      Fog::RiakCS[:provisioning].enable_user(key_id).status

    end

  end

  tests('User granted new key secret') do

    tests('is successful').returns(true) do

      # Create a user.
      #
      email, name        = "successful_user_regrant_test_#{current_timestamp}@example.com", "Fog User"
      user               = Fog::RiakCS[:provisioning].create_user(email, name).body
      key_id, key_secret = user['key_id'], user['key_secret']

      Fog::RiakCS[:provisioning].regrant_secret(key_id).status

      # Verify new secret.
      #
      new_key_secret = Fog::RiakCS[:provisioning].get_user(key_id).body['key_secret']
      new_key_secret != key_secret

    end

  end

  tests('User retrieval') do

    tests('is successful').formats(user_format) do

      # Create a user.
      #
      email, name = "user_retrieval_test_#{current_timestamp}@example.com", "Fog User"
      key_id      = Fog::RiakCS[:provisioning].create_user(email, name).body['key_id']

      # Get user details.
      #
      Fog::RiakCS[:provisioning].get_user(key_id).body

    end

  end

  tests('User listing') do

    tests('sucessfully lists users').formats(user_format) do

      # Create a user.
      #
      email, name = "user_listing_test_#{current_timestamp}@example.com", "Fog User"
      key_id      = Fog::RiakCS[:provisioning].create_user(email, name).body['key_id']

      # Ensure the list users response contains the user that we just
      # created.
      #
      Fog::RiakCS[:provisioning].list_users.body.select { |x| x['email'] == email }.first

    end

    tests('successfully lists users containing no disabled users').returns(nil) do

      # Create a user.
      #
      email, name = "user_listing_without_disabled_users_test_#{current_timestamp}@example.com", "Fog User"
      key_id      = Fog::RiakCS[:provisioning].create_user(email, name).body['key_id']

      # Disable that user.
      #
      Fog::RiakCS[:provisioning].disable_user(key_id)

      # Ensure the list users response does not contain the user that we
      # just created and disabled.
      #
      Fog::RiakCS[:provisioning].list_users(:status => :enabled).body.select { |x| x['Email'] == email }.first

    end

    tests('successfully lists users containing disabled users').formats(user_format) do

      # Create a user.
      #
      email, name = "user_listing_with_disabled_users_test_#{current_timestamp}@example.com", "Fog User"
      key_id      = Fog::RiakCS[:provisioning].create_user(email, name).body['key_id']

      # Disable that user.
      #
      Fog::RiakCS[:provisioning].disable_user(key_id)

      # Ensure the list users response contains the user that we just
      # created and disabled.
      #
      Fog::RiakCS[:provisioning].list_users.body.select { |x| x['email'] == email }.first

    end

  end

end
