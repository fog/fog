module Fog
  module Compute
    class XenServer
      class Real
        #
        # Create a VLAN
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=VLAN
        #
        def create_vlan( pif_ref, vlan_id, network_ref )
          @connection.request(
            {
              :parser => Fog::Parsers::XenServer::Base.new,
              :method => 'VLAN.create'
            },
            pif_ref,
            vlan_id.to_s,
            network_ref
          )
        end
      end

      class Mock
        def create_vlan( pif_ref, vlan_id, network_ref )
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
