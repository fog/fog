module Fog
  module Compute
    class  XenServer
      class Real
        def reboot_server( ref, stype = 'clean' )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => "VM.#{stype}_reboot"}, ref)
        end
      end

      class Mock
        def reboot_server( ref, stype )
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
