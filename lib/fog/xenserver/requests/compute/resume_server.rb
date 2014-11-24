module Fog
  module Compute
    class XenServer
      class Real
        def resume_server( ref, start_paused=false, force=false )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.resume'}, ref, start_paused, force)
        end
      end

      class Mock
        def resume_server( ref )
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
