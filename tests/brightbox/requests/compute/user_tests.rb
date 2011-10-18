Shindo.tests('Fog::Compute[:brightbox] | user requests', ['brightbox']) do

  tests('success') do

    tests("#list_users").formats(Brightbox::Compute::Formats::Collection::USERS) do
      pending if Fog.mocking?
      data = Fog::Compute[:brightbox].list_users
      @user_id = data.first["id"]
      data
    end

    tests("#get_user('#{@user_id}')").formats(Brightbox::Compute::Formats::Full::USER) do
      pending if Fog.mocking?
      data = Fog::Compute[:brightbox].get_user(@user_id)
      @original_name = data["name"]
      data
    end

    update_options = { :name => "Fog@#{Time.now.iso8601}" }

    tests("#update_user('#{@user_id}', #{update_options.inspect})").formats(Brightbox::Compute::Formats::Full::USER) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].update_user(@user_id, update_options)
    end

    unless Fog.mocking?
      Fog::Compute[:brightbox].update_user(@user_id, :name => @original_name)
    end

  end

  tests('failure') do

    tests("#update_user").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].update_user
    end

  end

end
