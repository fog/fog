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
      email, name = "successful_user_creation_test_#{current_timestamp}@example.com", "Fog User 0"
      user_id      = Fog::Radosgw[:provisioning].create_user(name, name, email).body['user_id']
      user_id.class

    end

    tests('fails if duplicate').raises(Fog::Radosgw::Provisioning::UserAlreadyExists) do
      2.times do
        email, name = "failed_duplicate_user_creation_test_#{current_timestamp}@example.com", "Fog User 1"
        user_id      = Fog::Radosgw[:provisioning].create_user(name, name, email).body['user_id']
      end
    end

  end

  tests('User delete') do

    tests('is successful').returns(200) do

      # Create a user.
      #
      email, name = "successful_user_delete_test_#{current_timestamp}@example.com", "Fog User 2"
      user_id      = Fog::Radosgw[:provisioning].create_user(name, name, email).body['user_id']

      Fog::Radosgw[:provisioning].delete_user(user_id).status

    end

    tests('is successful').returns(404) do

      # Create a user.
      #
      email, name = "successful_user_delete_test_2_#{current_timestamp}@example.com", "Fog User 3"
      user_id      = Fog::Radosgw[:provisioning].create_user(name, name, email).body['user_id']

      Fog::Radosgw[:provisioning].delete_user(user_id).status
      Fog::Radosgw[:provisioning].get_user(user_id).status

    end

  end

  tests('User disable') do

    tests('is successful').returns(200) do

      # Create a user.
      #
      email, name = "successful_user_disable_test_#{current_timestamp}@example.com", "Fog User 4"
      user_id      = Fog::Radosgw[:provisioning].create_user(name, name, email).body['user_id']

      Fog::Radosgw[:provisioning].disable_user(user_id).status

    end

  end

  tests('User enable') do

    tests('is successful').returns(200) do

      # Create a user.
      #
      email, name = "successful_user_disable_enable_test_#{current_timestamp}@example.com", "Fog User 5"
      user_id      = Fog::Radosgw[:provisioning].create_user(name, name, email).body['user_id']

      Fog::Radosgw[:provisioning].disable_user(user_id).status
      Fog::Radosgw[:provisioning].enable_user(user_id).status

    end

  end

  tests('User retrieval') do

    tests('is successful').formats(user_format) do

      # Create a user.
      #
      email, name = "user_retrieval_test_#{current_timestamp}@example.com", "Fog User 6"
      user_id      = Fog::Radosgw[:provisioning].create_user(name, name, email).body['user_id']

      # Get user details.
      #
      Fog::Radosgw[:provisioning].get_user(user_id).body

    end

  end

  tests('User listing') do

    tests('sucessfully lists users').formats(user_format) do

      # Create a user.
      #
      email, name = "user_listing_test_#{current_timestamp}@example.com", "Fog User 7"
      user_id      = Fog::Radosgw[:provisioning].create_user(name, name, email).body['user_id']

      # Ensure the list users response contains the user that we just
      # created.
      #
      Fog::Radosgw[:provisioning].list_users.body.select { |x| x['email'] == email }.first

    end

    tests('successfully lists users containing no disabled users').returns(nil) do

      # Create a user.
      #
      email, name = "user_listing_without_disabled_users_test_#{current_timestamp}@example.com", "Fog User 8"
      user_id      = Fog::Radosgw[:provisioning].create_user(name, name, email).body['user_id']

      # Disable that user.
      #
      Fog::Radosgw[:provisioning].disable_user(user_id)

      # Ensure the list users response does not contain the user that we
      # just created and disabled.
      #
      Fog::Radosgw[:provisioning].list_users(:suspended => 0).body.select { |x| x['email'] == email }.first

    end

    tests('successfully lists users containing disabled users').formats(user_format) do

      # Create a user.
      #
      email, name = "user_listing_with_disabled_users_test_#{current_timestamp}@example.com", "Fog User 9"
      user_id      = Fog::Radosgw[:provisioning].create_user(name, name, email).body['user_id']

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
