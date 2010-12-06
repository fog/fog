Shindo.tests('Brightbox::Compute | account requests', ['brightbox']) do

  tests('success') do

    tests("#get_account()").formats(Brightbox::Compute::Formats::Full::ACCOUNT) do
      Brightbox[:compute].get_account()
    end

    original_name = Brightbox[:compute].get_account["name"]
    update_args = {:name => "New name from Fog test"}
    tests("#update_account(#{update_args.inspect})").formats(Brightbox::Compute::Formats::Full::ACCOUNT) do
      Brightbox[:compute].update_account(update_args)
    end
    Brightbox[:compute].update_account(:name => original_name)

    tests("#reset_ftp_password_account()").formats(Brightbox::Compute::Formats::Full::ACCOUNT) do
      Brightbox[:compute].reset_ftp_password_account()
    end

  end

  tests('failure') do

    tests("#update_account()").returns(nil) do
      Brightbox[:compute].update_account()
    end
  end

end
