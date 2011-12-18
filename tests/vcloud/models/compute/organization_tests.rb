Shindo.tests("Vcloud::Compute | organization", ['vcloud']) do

  pending if Fog.mocking?

  instance = Fog::Vcloud::Compute.new(:vcloud_host => 'vcloud.example.com', :vcloud_username => 'username', :vcloud_password => 'password').organizations.first
  instance.reload

  tests("#href").returns('https://vcloud.example.com/api/v1.0/org/1'){ instance.href }
  tests("#name").returns('Org1'){ instance.name }
  tests("#full_name").returns('My Full Name'){ instance.full_name }
  tests("#description").returns("Some fancy\n\nDescription"){ instance.description }

end
