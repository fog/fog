Shindo.tests('Fog::Compute[:brightbox] | account requests', ['brightbox']) do

  tests('success') do

    tests("#list_accounts") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_accounts
      data_matches_schema(Brightbox::Compute::Formats::Collection::ACCOUNTS, {:allow_extra_keys => true}) { result }
    end

    tests("#get_scoped_account") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_scoped_account
      @scoped_account_identifier = result["id"]
      data_matches_schema(Brightbox::Compute::Formats::Full::ACCOUNT, {:allow_extra_keys => true}) { result }
      test("ftp password is blanked") { result["library_ftp_password"].nil?  }
    end

    tests("#get_account(#{@scoped_account_identifier}") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_account(@scoped_account_identifier)
      @current_name = result["name"]
      data_matches_schema(Brightbox::Compute::Formats::Full::ACCOUNT, {:allow_extra_keys => true}) { result }
      test("ftp password is blanked") { result["library_ftp_password"].nil?  }
    end

    update_options = { :name => @current_name }
    tests("#update_scoped_account(#{update_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].update_scoped_account(update_options)
      data_matches_schema(Brightbox::Compute::Formats::Full::ACCOUNT, {:allow_extra_keys => true}) { result }
    end

    tests("#update_account(#{@scoped_account_identifier}, #{update_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].update_account(@scoped_account_identifier, update_options)
      data_matches_schema(Brightbox::Compute::Formats::Full::ACCOUNT, {:allow_extra_keys => true}) { result }
    end

    tests("#reset_ftp_password_scoped_account") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].reset_ftp_password_scoped_account
      data_matches_schema(Brightbox::Compute::Formats::Full::ACCOUNT, {:allow_extra_keys => true}) { result }
      test("new ftp password is visible") { ! result["library_ftp_password"].nil?  }
    end

    tests("#reset_ftp_password_account(#{@scoped_account_identifier})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].reset_ftp_password_account(@scoped_account_identifier)
      data_matches_schema(Brightbox::Compute::Formats::Full::ACCOUNT, {:allow_extra_keys => true}) { result }
      test("new ftp password is visible") { ! result["library_ftp_password"].nil?  }
    end

  end

  tests('failure') do

    tests("#update_account").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].update_account
    end

  end

end
