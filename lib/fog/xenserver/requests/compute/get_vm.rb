module Fog
  module Compute
    class XenServer

      class Real
        
        require 'fog/xenserver/parser'
        
        def get_vm( name_label )
          vm_ref = @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.get_by_name_label'}, name_label)
          get_vm_by_ref( vm_ref )
        end
        
        def get_vm_by_ref( vm_ref )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.get_record'}, vm_ref).merge(:reference => vm_ref)
        end
      end
      
      class Mock
        
        def get_vm( uuid )
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
