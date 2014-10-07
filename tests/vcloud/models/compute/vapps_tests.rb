require 'fog/vcloud/models/compute/vapps'

Shindo.tests("Vcloud::Compute | vapps", ['vcloud']) do

  Fog::Vcloud::Compute::SUPPORTED_VERSIONS.each do |version|
    tests("api version #{version}") do
      pending if Fog.mocking?
      instance = Fog::Vcloud::Compute::Vapps.new(
        :connection => Fog::Vcloud::Compute.new(:vcloud_host => 'vcloud.example.com', :vcloud_username => 'username', :vcloud_password => 'password'),
        :href       =>  "https://vcloud.example.com/api#{(version == '1.0') ? '/v1.0' : ''}/vdc/1"
      )

      tests("collection") do
        returns(2) { instance.size }
        returns("https://vcloud.example.com/api#{(version == '1.0') ? '/v1.0' : ''}/vApp/vapp-1") { instance.first.href }
      end
    end
  end
end
