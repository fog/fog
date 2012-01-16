require 'fog/vcloud/models/compute/organizations'

Shindo.tests("Vcloud::Compute | organizations", ['vcloud']) do

  pending if Fog.mocking?

  instance = Fog::Vcloud::Compute.new(:vcloud_host => 'vcloud.example.com', :vcloud_username => 'username', :vcloud_password => 'password').organizations

  tests("collection") do
    returns(2) { instance.size }
    returns("https://vcloud.example.com/api/v1.0/org/1") { instance.first.href }
  end

end
