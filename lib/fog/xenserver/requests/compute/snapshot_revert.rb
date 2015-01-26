module Fog
  module Compute
    class XenServer
      class Real
        def revert_server( snapshot_ref, extra_args = {})
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.revert'}, snapshot_ref)
        end

        def snapshot_revert(snapshot_ref, extra_args = {})
          Fog::Logger.deprecation(
              'This method is deprecated. Use #revert_server instead.'
          )
          revert_server(snapshot_ref, extra_args)
        end
      end

      class Mock
        def revert_server()
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
