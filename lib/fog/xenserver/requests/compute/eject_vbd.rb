module Fog
  module Compute
    class XenServer

      class Real

        def eject_vbd(ref, extra_args = {})
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VBD.eject'}, ref)
        end

      end

      class Mock

        def eject_vbd(ref, extra_args = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
