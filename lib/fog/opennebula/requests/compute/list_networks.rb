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
	  #{"VNET"=>{"ID"=>"155", "UID"=>"0", "GID"=>"1", "UNAME"=>"oneadmin", "GNAME"=>"users", "NAME"=>"vlan99-2", "PERMISSIONS"=>{"OWNER_U"=>"1", "OWNER_M"=>"1", "OWNER_A"=>"0", "GROUP_U"=>"1", "GROUP_M"=>"0", "GROUP_A"=>"0", "OTHER_U"=>"0", "OTHER_M"=>"0", "OTHER_A"=>"0"}, "CLUSTER_ID"=>"-1", "CLUSTER"=>{}, "TYPE"=>"0", "BRIDGE"=>"ovsbr", "VLAN"=>"1", "PHYDEV"=>{}, "VLAN_ID"=>"99", "GLOBAL_PREFIX"=>{}, "SITE_PREFIX"=>{}, "RANGE"=>{"IP_START"=>"10.10.99.127", "IP_END"=>"10.10.99.249"}, "TOTAL_LEASES"=>"0", "TEMPLATE"=>{"DESCRIPTION"=>"test", "NETWORK_ADDRESS"=>"10.10.99.0", "NETWORK_MASK"=>"255.255.255.0"}}}
          h = {
            :id    	 => net["VNET"]["ID"],
            :name  	 => net["VNET"]["NAME"],
	    :uid   	 => net["VNET"]["UID"],
	    :gid   	 => net["VNET"]["GID"],
          }

	  h[:description] = net["VNET"]["TEMPLATE"]["DESCRIPTION"] unless net["VNET"]["TEMPLATE"]["DESCRIPTION"].nil?
	  h[:vlan] 	  = net["VNET"]["VLAN_ID"] unless (net["VNET"]["VLAN_ID"].nil? || net["VNET"]["VLAN_ID"].empty?)

	  return h
        end

      end

      class Mock
        def list_networks(filters={})
          net1 = mock_network 'net1'
          net2 = mock_network 'net2'
          [net1, net2]
        end

        def mock_network name
          {
            :id    	 => "5",
            :name  	 => name,
	    :uid   	 => "5",
	    :gid   	 => "5",
	    :description => "netDescription",
	    :vlan	 => "5"
          }
        end
      end
    end
  end
end
