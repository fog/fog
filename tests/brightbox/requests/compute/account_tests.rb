Shindo.tests('Brightbox::Compute | account requests', ['brightbox']) do

  tests('success') do

    tests("#get_account").formats(Brightbox::Compute::Formats::Full::ACCOUNT) do
      pending if Fog.mocking?
      Brightbox[:compute].get_account
    end

    unless Fog.mocking?
      original_name = Brightbox[:compute].get_account["name"]
      update_args = {:name => "New name from Fog test"}
    end

    tests("#update_account(#{update_args.inspect})").formats(Brightbox::Compute::Formats::Full::ACCOUNT) do
      pending if Fog.mocking?
      Brightbox[:compute].update_account(update_args)
    end

    unless Fog.mocking?
      Brightbox[:compute].update_account(:name => original_name)
    end

    tests("#reset_ftp_password_account").formats(Brightbox::Compute::Formats::Full::ACCOUNT) do
      pending if Fog.mocking?
      Brightbox[:compute].reset_ftp_password_account
    end

  end

  tests('failure') do

    tests("#update_account").returns(nil) do
      pending if Fog.mocking?
      Brightbox[:compute].update_account
    end

  end

end
