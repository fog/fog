Shindo.tests('Fog::Compute[:brightbox] | account requests', ['brightbox']) do

  tests('success') do

    tests("#get_account").formats(Brightbox::Compute::Formats::Full::ACCOUNT) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_account
    end

    unless Fog.mocking?
      original_name = Fog::Compute[:brightbox].get_account["name"]
      update_args = {:name => "New name from Fog test"}
    end

    tests("#update_account(#{update_args.inspect})").formats(Brightbox::Compute::Formats::Full::ACCOUNT) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].update_account(update_args)
    end

    unless Fog.mocking?
      Fog::Compute[:brightbox].update_account(:name => original_name)
    end

    tests("#reset_ftp_password_account").formats(Brightbox::Compute::Formats::Full::ACCOUNT) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].reset_ftp_password_account
    end

  end

  tests('failure') do

    tests("#update_account").returns(nil) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].update_account
    end

  end

end
