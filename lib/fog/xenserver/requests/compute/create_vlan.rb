module Fog
  module Compute
    class XenServer
      class Real
        #
        # Create a VLAN
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=VLAN
        #
        def create_vlan( pif_ref, vlan_id, network_ref = '' )
          if pif_ref.is_a?(Hash)
            config = pif_ref
            extra_config = vlan_id

            pif_ref = extra_config[:pif_ref]
            tag = config[:tag].to_s
            network_ref = extra_config[:network_ref]
          else
            Fog::Logger.deprecation(
                'This api is deprecated. The only expected params are two hash of attributes.'
            )
            tag = vlan_id.to_s
          end
          @connection.request(
            {
              :parser => Fog::Parsers::XenServer::Base.new,
              :method => 'VLAN.create'
            },
            pif_ref,
            tag,
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
