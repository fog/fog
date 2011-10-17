Shindo.tests('Fog::Compute[:brightbox] | account requests', ['brightbox']) do

  tests('success') do

    tests("#get_account").formats(Brightbox::Compute::Formats::Full::ACCOUNT) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_account
    end

    update_options = {:name => "Fog@#{Time.now.iso8601}"}
    tests("#update_account(#{update_options.inspect})").formats(Brightbox::Compute::Formats::Full::ACCOUNT) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].update_account(update_options)
    end

    tests("#reset_ftp_password_account").formats(Brightbox::Compute::Formats::Full::ACCOUNT) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].reset_ftp_password_account
    end

  end

  tests('failure') do

    tests("#update_account").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].update_account
    end

  end

end
