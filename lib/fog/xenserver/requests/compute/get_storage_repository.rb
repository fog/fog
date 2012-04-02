module Fog
  module Compute
    class XenServer

      class Real
        
        require 'fog/xenserver/parser'
        
        def get_storage_repository( name_label )
          sr_ref = @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'SR.get_by_name_label'}, name_label)
          get_storage_repository_by_ref( sr_ref )
        end
        
        def get_storage_repository_by_ref( sr_ref )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'SR.get_record'}, sr_ref).merge(:reference => sr_ref)
        end
      end
      
      class Mock
        
        def get_storage_repository( uuid )
          Fog::Mock.not_implemented
        end

        def get_storage_repository_by_ref( sr_ref )
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
