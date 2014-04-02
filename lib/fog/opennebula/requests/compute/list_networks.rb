#1.9.3-p545 :017 > netpool.entries.first.to_hash
# => {"VNET"=>{"ID"=>"4", "UID"=>"0", "GID"=>"0", "UNAME"=>"oneadmin", "GNAME"=>"oneadmin", "NAME"=>"vlan116", "PERMISSIONS"=>{"OWNER_U"=>"1", "OWNER_M"=>"1", "OWNER_A"=>"0", "GROUP_U"=>"0", "GROUP_M"=>"0", "GROUP_A"=>"0", "OTHER_U"=>"0", "OTHER_M"=>"0", "OTHER_A"=>"0"}, "CLUSTER_ID"=>"-1", "CLUSTER"=>{}, "TYPE"=>"0", "BRIDGE"=>"br116", "VLAN"=>"0", "PHYDEV"=>{}, "VLAN_ID"=>{}, "GLOBAL_PREFIX"=>{}, "SITE_PREFIX"=>{}, "RANGE"=>{"IP_START"=>"192.168.0.1", "IP_END"=>"192.168.0.254"}, "TOTAL_LEASES"=>"6", "TEMPLATE"=>{"NETWORK_MASK"=>"255.255.0.0"}}}
#
module Fog
  module Compute
    class OpenNebula
      class Real
        def list_networks(filter = { })

          networks=[]
            netpool = ::OpenNebula::VirtualNetworkPool.new(client)
            if filter[:id].nil?
              netpool.info!(-2,-1,-1)
            elsif filter[:id]
              filter[:id] = filter[:id].to_i if filter[:id].is_a?(String)
              netpool.info!(-2, filter[:id], filter[:id])
            end # if filter[:id].nil?
 
          netpool.each do |network| 
	    networks << network_to_attributes(network.to_hash)
	  end
          networks
        end

        def network_to_attributes(net)
          return if net.nil?
          {
            :id    => net["VNET"]["ID"],
            :name  => net["VNET"]["NAME"],
	    :uid   => net["VNET"]["UID"],
	    :gid   => net["VNET"]["GID"]
          }
        end

      end

      class Mock
        def list_networks(filters={ })
          net1 = mock_network 'net1'
          net2 = mock_network 'net2'
          [net1, net2]
        end

        def mock_network name
          {
              :uuid        => 'net.uuid',
              :name        => name,
              :bridge_name => 'net.bridge_name'
          }
        end
      end
    end
  end
end
