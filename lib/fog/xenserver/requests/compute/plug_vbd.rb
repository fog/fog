module Fog
  module Compute
    class XenServer

      class Real

        def plug_vbd( vbd_ref, extra_args = {})
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VBD.plug'}, vbd_ref)
        end


      end

      class Mock
        def plug_vbd( vbd_ref, extra_args = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
