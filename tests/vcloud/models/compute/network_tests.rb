require "#{File.dirname(__FILE__)}/conn_helper.rb"

require 'fog/vcloud/models/compute/networks'

Shindo.tests("Vcloud::Compute | network", ['vcloud']) do
  connection = Fog::Vcloud::Compute.new(:vcloud_host => 'vcloud.example.com', :vcloud_username => 'username', :vcloud_password => 'password')
  tests("an org network") do
    instance = Fog::Vcloud::Compute::Networks.new(
      :connection => connection,
      :href       =>  "https://vcloud.example.com/api/v1.0/vApp/vapp-1"
    ).first
    instance.reload

    tests("#href").returns("https://vcloud.example.com/api/v1.0/network/1") { instance.href }
    tests("#name").returns("Network1") { instance.name }
    tests("#description").returns("Some fancy Network") { instance.description }

    tests("configuration") do
      tests("parent network").returns("ParentNetwork1") { instance.configuration[:ParentNetwork][:name]}
      tests("dns").returns("172.0.0.2") { instance.configuration[:IpScope][:Dns1]}
    end
  end

  tests("an external network") do
    instance = Fog::Vcloud::Compute::Network.new(
      :connection => connection,
      :collection => Fog::Vcloud::Compute::Networks.new(:connection => connection),
      :href => "https://vcloud.example.com/api/v1.0/admin/network/2"
    )
    instance.reload
    tests("#href").returns("https://vcloud.example.com/api/v1.0/admin/network/2") { instance.href }
    tests("#name").returns("ParentNetwork1") { instance.name }
    tests("#description").returns("Internet Connection") { instance.description }

    tests("configuration") do
      tests("dns").returns("172.0.0.2") { instance.configuration[:IpScope][:Dns1]}
      tests("allocated addresses").returns("172.0.0.144") { instance.configuration[:IpScope][:AllocatedIpAddresses][:IpAddress].first }
    end
  end
end
