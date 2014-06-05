module Fog
  module Compute
    class XenServer
      class Real
        def destroy_vdi( vdi_ref, extra_args = {})
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VDI.destroy'}, vdi_ref)
        end
      end

      class Mock
        def destroy_vdi()
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
