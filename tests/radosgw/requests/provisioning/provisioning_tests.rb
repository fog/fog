Shindo.tests('Radosgw::Provisioning | provisioning requests', ['radosgw']) do

  current_timestamp = Time.now.to_i

  user_format = {
    'email'        => String,
    'display_name' => String,
    'user_id'      => String,
    'suspended'    => Integer,
    'keys'         =>
    [
     {
       'access_key' => String,
       'secret_key' => String,
       'user'       => String,
     }
    ],
  }

  tests('User creation') do

    tests('is successful').returns(String) do

      # Create a user.
      #
      email, name = "successful_user_creation_test_#{current_timestamp}@example.com", "Fog User"
      user_id      = Fog::Radosgw[:provisioning].create_user(email, name).body['user_id']
      user_id.class

    end

    tests('is successful anonymously').returns(String) do

      # Create a user.
      #
      email, name = "successful_anonymous_user_creation_test_#{current_timestamp}@example.com", "Fog User"
      user_id      = Fog::Radosgw[:provisioning].create_user(email, name, :anonymous => true).body['user_id']
      user_id.class

    end

    tests('fails if duplicate').raises(Fog::Radosgw::Provisioning::UserAlreadyExists) do
      2.times do
        email, name = "failed_duplicate_user_creation_test_#{current_timestamp}@example.com", "Fog User"
        user_id      = Fog::Radosgw[:provisioning].create_user(email, name).body['user_id']
      end
    end

    tests('fails if invalid email').raises(Fog::Radosgw::Provisioning::ServiceUnavailable) do
      email, name = "failed_duplicate_user_creation_test_#{current_timestamp}", "Fog User"
      user_id      = Fog::Radosgw[:provisioning].create_user(email, name).body['user_id']
    end

  end

  tests('User disable') do

    tests('is successful').returns(200) do

      # Create a user.
      #
      email, name = "successful_user_disable_test_#{current_timestamp}@example.com", "Fog User"
      user_id      = Fog::Radosgw[:provisioning].create_user(email, name).body['user_id']

      Fog::Radosgw[:provisioning].disable_user(user_id).status

    end

  end

  tests('User enable') do

    tests('is successful').returns(200) do

      # Create a user.
      #
      email, name = "successful_user_disable_enable_test_#{current_timestamp}@example.com", "Fog User"
      user_id      = Fog::Radosgw[:provisioning].create_user(email, name).body['user_id']

      Fog::Radosgw[:provisioning].disable_user(user_id).status
      Fog::Radosgw[:provisioning].enable_user(user_id).status

    end

  end

  tests('User granted new key secret') do

    tests('is successful').returns(true) do

      # Create a user.
      #
      email, name         = "successful_user_regrant_test_#{current_timestamp}@example.com", "Fog User"
      user                = Fog::Radosgw[:provisioning].create_user(email, name).body
      user_id, secret_key = user['user_id'], user['keys'][0]['secret_key']

      Fog::Radosgw[:provisioning].regrant_secret(user_id).status

      # Verify new secret.
      #
      new_secret_key = Fog::Radosgw[:provisioning].get_user(user_id).body['secret_key']
      new_secret_key != secret_key

    end

  end

  tests('User retrieval') do

    tests('is successful').formats(user_format) do

      # Create a user.
      #
      email, name = "user_retrieval_test_#{current_timestamp}@example.com", "Fog User"
      user_id      = Fog::Radosgw[:provisioning].create_user(email, name).body['user_id']

      # Get user details.
      #
      Fog::Radosgw[:provisioning].get_user(user_id).body

    end

  end

  tests('User listing') do

    tests('sucessfully lists users').formats(user_format) do

      # Create a user.
      #
      email, name = "user_listing_test_#{current_timestamp}@example.com", "Fog User"
      user_id      = Fog::Radosgw[:provisioning].create_user(email, name).body['user_id']

      # Ensure the list users response contains the user that we just
      # created.
      #
      Fog::Radosgw[:provisioning].list_users.body.select { |x| x['email'] == email }.first

    end

    tests('successfully lists users containing no disabled users').returns(nil) do

      # Create a user.
      #
      email, name = "user_listing_without_disabled_users_test_#{current_timestamp}@example.com", "Fog User"
      user_id      = Fog::Radosgw[:provisioning].create_user(email, name).body['user_id']

      # Disable that user.
      #
      Fog::Radosgw[:provisioning].disable_user(user_id)

      # Ensure the list users response does not contain the user that we
      # just created and disabled.
      #
      Fog::Radosgw[:provisioning].list_users(:suspended => 0).body.select { |x| x['Email'] == email }.first

    end

    tests('successfully lists users containing disabled users').formats(user_format) do

      # Create a user.
      #
      email, name = "user_listing_with_disabled_users_test_#{current_timestamp}@example.com", "Fog User"
      user_id      = Fog::Radosgw[:provisioning].create_user(email, name).body['user_id']

      # Disable that user.
      #
      Fog::Radosgw[:provisioning].disable_user(user_id)

      # Ensure the list users response contains the user that we just
      # created and disabled.
      #
      Fog::Radosgw[:provisioning].list_users.body.select { |x| x['email'] == email }.first

    end

  end

end
