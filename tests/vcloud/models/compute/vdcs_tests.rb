require "#{File.dirname(__FILE__)}/conn_helper.rb"

require 'fog/vcloud/models/compute/vdcs'

Shindo.tests("Vcloud::Compute | vdcs", ['vcloud']) do

   instance = Fog::Vcloud::Compute::Vdcs.new(
    :connection => Fog::Vcloud::Compute.new(:vcloud_host => 'vcloud.example.com', :vcloud_username => 'username', :vcloud_password => 'password'),
    :href       =>  "https://vcloud.example.com/api/v1.0/org/1"
   )

  tests("collection") do
    returns(1) { instance.size }
    returns("https://vcloud.example.com/api/v1.0/vdc/1") { instance.first.href }
  end

end
