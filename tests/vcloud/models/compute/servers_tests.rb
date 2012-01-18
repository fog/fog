require 'fog/vcloud/models/compute/servers'

Shindo.tests("Vcloud::Compute | servers", ['vcloud']) do

  pending if Fog.mocking?

  instance = Fog::Vcloud::Compute::Servers.new(
    :connection => Fog::Vcloud::Compute.new(:vcloud_host => 'vcloud.example.com', :vcloud_username => 'username', :vcloud_password => 'password'),
    :href       =>  "https://vcloud.example.com/api/v1.0/vApp/vapp-1"
  )

  tests("collection") do
    returns(2) { instance.size }
    returns("https://vcloud.example.com/api/v1.0/vApp/vm-2") { instance.first.href }
  end
end
