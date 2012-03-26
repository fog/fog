require 'fog/vcloud/models/compute/networks'

Shindo.tests("Vcloud::Compute | network", ['vcloud']) do

  Fog::Vcloud::Compute::SUPPORTED_VERSIONS.each do |version|
    tests("api version #{version}") do
      pending if Fog.mocking?

      connection = Fog::Vcloud::Compute.new(
        :vcloud_host => 'vcloud.example.com',
        :vcloud_username => 'username',
        :vcloud_password => 'password',
        :vcloud_version => version
      )
      tests("an org network") do
        instance = connection.get_network("https://vcloud.example.com/api#{version == '1.0' ? '/v1.0' : ''}/network/1")
        instance.reload
    
        tests("#href").returns("https://vcloud.example.com/api#{version == '1.0' ? '/v1.0' : ''}/network/1") { instance.href }
        tests("#name").returns("Network1") { instance.name }
        tests("#description").returns("Some fancy Network") { instance.description }
    
        tests("configuration") do
          tests("parent network").returns("ParentNetwork1") { instance.configuration[:ParentNetwork][:name]}
          tests("dns").returns("172.0.0.2") { instance.configuration[:IpScope][:Dns1]}
          
          tests("#fence_mode").returns("natRouted") { instance.configuration[:FenceMode] }
          
          tests("features") do
            tests("dhcp_service") do
              tests("#is_enabled").returns("false") { instance.configuration[:Features][:DhcpService][:IsEnabled] }
              tests("ip_range") do
                tests("#start_address").returns("192.168.0.151") { instance.configuration[:Features][:DhcpService][:IpRange][:StartAddress] }
              end
            end
            tests("firewall_server") do
              tests("is_enabled").returns("true"){ instance.configuration[:Features][:FirewallService][:IsEnabled] }
            end
            tests("nat_service") do
              tests("is_enabled").returns("false"){ instance.configuration[:Features][:NatService][:IsEnabled] }
            end
          end
        end
        
        tests("#parent_network") do
          tests("returned network name").returns("ParentNetwork1"){ p = instance.parent_network; p.name }
        end
      end
    
      tests("an external network") do
        instance = connection.get_network("https://vcloud.example.com/api#{version == '1.0' ? '/v1.0' : ''}/admin/network/2")
        instance.reload
        tests("#href").returns("https://vcloud.example.com/api#{version == '1.0' ? '/v1.0' : ''}/admin/network/2") { instance.href }
        tests("#name").returns("ParentNetwork1") { instance.name }
        tests("#description").returns("Internet Connection") { instance.description }
        tests("#provider_info").returns("NETWORK:dvportgroup-230 on com.vmware.vcloud.entity.vimserver:35935555") { instance.provider_info }
    
        tests("configuration") do
          tests("dns").returns("172.0.0.2") { instance.configuration[:IpScope][:Dns1]}
          tests("allocated addresses").returns("172.0.0.144") { instance.configuration[:IpScope][:AllocatedIpAddresses][:IpAddress].first }
        end
    
        tests("#parent_network").returns(nil){ instance.parent_network }
      end
    end
  end
end
