module Fog
  module Compute
    class XenServer
      class Real
        #
        # Destroy a Network
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=network
        #
        def destroy_network( ref )
          Fog::Logger.deprecation(
              'This method is deprecated. Use #destroy_record instead.'
          )
          @connection.request(
            {
              :parser => Fog::Parsers::XenServer::Base.new,
              :method => 'network.destroy'
            },
            ref
          )
        end
      end

      class Mock
        def destroy_network( ref )
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
