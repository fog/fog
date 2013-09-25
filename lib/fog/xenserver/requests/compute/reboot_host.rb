module Fog
  module Compute
    class  XenServer

      class Real
        
        def reboot_host( ref )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => "host.reboot"}, ref)
        end
        
      end
      
      class Mock
        
        def reboot_host( ref )
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
