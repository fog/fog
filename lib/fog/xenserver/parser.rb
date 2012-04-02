module Fog
  module Parsers
    module XenServer
      class Base
        
        attr_reader :response
        
        def initialize
          reset
        end
        
        def reset
          @response = {}
        end
        
        def parse( data )
          if data.is_a? Hash
            @response = data.symbolize_keys!
          elsif data.is_a? Array
            @response = data.first
          end
          
          @response
        end
        
      end
    end
  end
end