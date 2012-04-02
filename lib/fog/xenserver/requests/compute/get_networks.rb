module Fog
  module XenServer
    class Real
      
      require 'fog/xenserver/parsers/get_networks'
      
      def get_networks( options = {} )
        options[:sort] ||= 'name_label'
        result = @connection.request(:parser => Fog::Parsers::XenServer::GetNetworks.new, :method => 'network.get_all_records')
        result.sort! {|a,b| a[ options[:sort].to_sym ] <=> b[ options[:sort].to_sym ]}
      end
      
    end
    
    class Mock
      
      def get_networks
        Fog::Mock.not_implemented
      end
      
    end
  end
end
