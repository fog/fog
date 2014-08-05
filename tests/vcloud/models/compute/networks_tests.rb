require 'fog/vcloud/models/compute/networks'

Shindo.tests("Vcloud::Compute | networks", ['vcloud']) do

  Fog::Vcloud::Compute::SUPPORTED_VERSIONS.each do |version|
    tests("api version #{version}") do
      pending if Fog.mocking?

      tests("from an org perspective") do
        instance = Fog::Vcloud::Compute::Networks.new(
          :connection => Fog::Vcloud::Compute.new(
            :vcloud_host => 'vcloud.example.com',
            :vcloud_username => 'username',
            :vcloud_password => 'password',
            :vcloud_version => version
            ),
          :href       =>  "https://vcloud.example.com/api#{version == '1.0' ? '/v1.0' : ''}/org/1"
        )

        tests("collection") do
          returns(2) { instance.size }
          returns("https://vcloud.example.com/api#{version == '1.0' ? '/v1.0' : ''}/network/1") { instance.first.href }
        end
      end

      tests("from a vdc perspective") do
        instance = Fog::Vcloud::Compute::Networks.new(
          :connection => Fog::Vcloud::Compute.new(
            :vcloud_host => 'vcloud.example.com',
            :vcloud_username => 'username',
            :vcloud_password => 'password',
            :vcloud_version => version
            ),
          :href       =>  "https://vcloud.example.com/api#{version == '1.0' ? '/v1.0' : ''}/vdc/1"
        )

        tests("collection") do
          returns(2) { instance.size }
          returns("https://vcloud.example.com/api#{version == '1.0' ? '/v1.0' : ''}/network/1") { instance.first.href }
        end
      end

      tests("from a vapp perspective") do
        instance = Fog::Vcloud::Compute::Networks.new(
          :connection => Fog::Vcloud::Compute.new(
            :vcloud_host => 'vcloud.example.com',
            :vcloud_username => 'username',
            :vcloud_password => 'password',
            :vcloud_version => version
            ),
          :href       =>  "https://vcloud.example.com/api#{version == '1.0' ? '/v1.0' : ''}/vApp/vapp-1"
        )

        tests("collection") do
          returns(1) { instance.size }
          returns("https://vcloud.example.com/api#{version == '1.0' ? '/v1.0' : ''}/network/1") { instance.first.href }
        end
      end
    end
  end
end
