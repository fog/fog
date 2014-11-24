module Fog
  module Compute
    class XenServer
      class Real
        def suspend_server( ref )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.suspend'}, ref)
        end
      end

      class Mock
        def suspend_server( ref )
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
