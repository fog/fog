module Fog
  module Compute
    class XenServer

      class Real
        
        require 'fog/xenserver/parser'
        
        def get_pool_by_ref( pool_ref )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.get_record'}, pool_ref).merge(:reference => pool_ref)
        end
      end
      
      class Mock
        
        def get_pool( uuid )
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
