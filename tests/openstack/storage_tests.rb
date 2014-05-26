Shindo.tests('Fog::Storage[:openstack]', ['openstack', 'storage']) do

  storage = Fog::Storage[:openstack]
  original_path = storage.instance_variable_get :@path

  tests("account changes") do
    test("#change_account") do
      new_account = 'AUTH_1234567890'
      storage.change_account new_account
      storage.instance_variable_get(:@path) != original_path
    end
    test("#reset_account_name") do
      storage.reset_account_name
      storage.instance_variable_get(:@path) == original_path
    end
  end

end
