module Fog
  module Compute
    class XenServer

      class Real

        # 
        # Destroy a Storage Repository
        #
        # http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=SR
        #
        def destroy_sr( sr_ref )
          @connection.request(
            {:parser => Fog::Parsers::XenServer::Base.new, :method => 'SR.destroy'}, 
            sr_ref
          )
        end

      end

      class Mock

        def destroy_sr( sr_ref )
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
