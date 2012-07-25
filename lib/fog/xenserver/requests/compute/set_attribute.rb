module Fog
  module Compute
    class XenServer

      class Real
        
        require 'fog/xenserver/parser'
        
        def set_attribute( klass, ref, attr_name, *value )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => "#{klass}.set_#{attr_name.gsub('-','_')}"}, ref, *value)
        end
        
      end
      
      class Mock
        
        def set_attribute( klass, ref, attr_name, value )
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
