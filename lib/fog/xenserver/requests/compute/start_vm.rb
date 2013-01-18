module Fog
  module Compute
    class  XenServer

      class Real
        
        # http://bit.ly/8ZPyCN
        # VM.start( session, VM_ref, start_paused, force)
        def start_vm( vm_ref )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.start'}, vm_ref, false, false)
        end
        
      end
      
      class Mock
        
        def start_vm( vm_ref )
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
