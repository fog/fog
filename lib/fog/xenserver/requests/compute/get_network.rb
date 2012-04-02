module Fog
  module XenServer
    class Real
      
      require 'fog/xenserver/parser'
      
      def get_network( name_label )
        network_ref = @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'network.get_by_name_label'}, name_label)
        get_network_by_ref( network_ref )
      end
      
      def get_network_by_ref( network_ref )
        @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'network.get_record'}, network_ref).merge(:reference => network_ref)
      end
      
    end
    
    class Mock
      
      def get_network( uuid )
        Fog::Mock.not_implemented
      end
      
    end
  end
end
