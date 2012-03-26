require 'fog/vcloud/models/compute/vdcs'
require 'fog/vcloud/models/compute/vdc'

Shindo.tests("Vcloud::Compute | vdc", ['vcloud']) do

  Fog::Vcloud::Compute::SUPPORTED_VERSIONS.each do |version|
    tests("api version #{version}") do
      pending if Fog.mocking?
      instance = Fog::Vcloud::Compute.new(
        :vcloud_host => 'vcloud.example.com',
        :vcloud_username => 'username',
        :vcloud_password => 'password',
        :vcloud_version => version
      ).get_vdc("https://vcloud.example.com/api#{(version == '1.0') ? '/v1.0' : ''}/vdc/1")
    
      instance.reload
    
      tests("#href").returns("https://vcloud.example.com/api#{(version == '1.0') ? '/v1.0' : ''}/vdc/1") { instance.href }
      tests("#name").returns("vDC1") { instance.name }
      tests('#organization').returns("Org1") { instance.organization.name }
      tests("#description").returns("Some Description") { instance.description }
      tests("#network_quota").returns(10) { instance.network_quota }
      tests("#nic_quota").returns(10) { instance.nic_quota }
      tests("#vm_quota").returns(10) { instance.vm_quota }
      tests("#is_enabled").returns(true) { instance.is_enabled }
    
      tests("#available_networks") do
        tests("#size").returns(2) { instance.available_networks.size }
      end
    
      tests("#storage_capacity") do
        tests("units").returns("MB") { instance.storage_capacity[:Units] }
        tests("allocated").returns("10240") { instance.storage_capacity[:Allocated] }
      end
    
      tests("#compute_capacity") do
        tests("cpu") do
          tests("allocated").returns("20000") { instance.compute_capacity[:Cpu][:Allocated] }
          tests("units").returns("MHz") { instance.compute_capacity[:Cpu][:Units] }
        end
        tests("memory") do
          tests("allocated").returns("1024") { instance.compute_capacity[:Memory][:Allocated] }
          tests("units").returns("MB") { instance.compute_capacity[:Memory][:Units] }
        end
      end
    end
  end
end
