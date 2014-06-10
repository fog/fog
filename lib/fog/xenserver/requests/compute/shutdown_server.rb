module Fog
  module Compute
    class  XenServer
      class Real
        def shutdown_server( vm_ref, stype = 'clean' )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => "VM.#{stype}_shutdown"}, vm_ref)
        end
      end

      class Mock
        def shutdown_server( vm_ref )
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
