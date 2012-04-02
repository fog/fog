module Fog
  module Compute
   class XenServer 

      class Real
        
        require 'fog/xenserver/parsers/get_pools'
        
        def get_pools( options = {} )
          options[:sort] ||= 'name_label'
          result = @connection.request(:parser => Fog::Parsers::XenServer::GetPools.new, :method => 'pool.get_all_records')
          result.sort! {|a,b| a[ options[:sort].to_sym ] <=> b[ options[:sort].to_sym ]}
        end
        
      end
      
      class Mock
        
        def get_pools
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
