module Fog
  module Compute
    class XenServer

      class Real

        def insert_vbd(ref, vdi_ref, extra_args = {})
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VBD.insert'}, ref, vdi_ref)
        end

      end

      class Mock

        def insert_vbd(ref, vdi_ref, extra_args = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
