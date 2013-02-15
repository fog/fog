module Fog
  module Compute
    class  XenServer

      class Real
        
        # 
        # Puts the host into a state in which no new VMs can be started. 
        # Currently active VMs on the host continue to execute.
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=host
        #
        def disable_host( ref )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => "host.disable"}, ref)
        end
        
      end
      
      class Mock
        
        def disable_host( ref )
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
