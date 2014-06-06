module Fog
  module Compute
    class XenServer
      class Real
        def snapshot_revert( snapshot_ref, extra_args = {})
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.revert'}, snapshot_ref)
        end
      end

      class Mock
        def snapshot_revert()
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
