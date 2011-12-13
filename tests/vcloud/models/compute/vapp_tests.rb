require 'fog/vcloud/models/compute/vapps'
require 'fog/vcloud/models/compute/vapp'

Shindo.tests("Vcloud::Compute | vapp", ['vcloud']) do

  pending if Fog.mocking?

  instance = Fog::Vcloud::Compute::Vapps.new(
    :connection => Fog::Vcloud::Compute.new(:vcloud_host => 'vcloud.example.com', :vcloud_username => 'username', :vcloud_password => 'password'),
    :href       =>  "https://vcloud.example.com/api/v1.0/vdc/1"
  ).first
  instance.reload

  tests("#href").returns("https://vcloud.example.com/api/v1.0/vApp/vapp-1") { instance.href }
  tests("#name").returns("vApp1") { instance.name }
  tests("#description").returns("Some Description of a vApp") { instance.description }
  tests("#status").returns('8') { instance.status }
  tests("#deployed").returns(true) { instance.deployed }

  tests("#children").returns(2) { instance.children.size }
  tests("#servers").returns(2) { instance.servers.size }

  tests("#friendly_status").returns('off') { instance.friendly_status }
  tests("#on?").returns(false) { instance.on? }
  tests("#off?").returns(true) { instance.off? }

end
