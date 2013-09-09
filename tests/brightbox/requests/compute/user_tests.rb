Shindo.tests('Fog::Compute[:brightbox] | user requests', ['brightbox']) do

  tests('success') do

    tests("#list_users") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_users
      @user_id = result.first["id"]
      data_matches_schema(Brightbox::Compute::Formats::Collection::USERS, {:allow_extra_keys => true}) { result }
    end

    tests("#get_user('#{@user_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_user(@user_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::USER, {:allow_extra_keys => true}) { result }
    end

    update_options = { :name => "Example User" }
    tests("#update_user('#{@user_id}', #{update_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].update_user(@user_id, update_options)
      data_matches_schema(Brightbox::Compute::Formats::Full::USER, {:allow_extra_keys => true}) { result }
    end

  end

  tests('failure') do

    tests("#update_user").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].update_user
    end

  end

end
