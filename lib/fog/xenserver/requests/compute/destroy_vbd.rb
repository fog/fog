module Fog
  module Compute
    class XenServer

      class Real

        def destroy_vbd( vbd_ref, extra_args = {})
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VBD.destroy'}, vbd_ref)
        end

      end

      class Mock

        def destroy_vbd()
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
