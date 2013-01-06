module Fog
  module Compute
    class  XenServer

      class Real
        
        # 
        # Puts the host into a state in which VMs can be started. 
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=host
        #
        def enable_host( ref )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => "host.enable"}, ref)
        end
        
      end
      
      class Mock
        
        def enable_host( ref )
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
