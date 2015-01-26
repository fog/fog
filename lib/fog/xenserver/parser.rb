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
          if data.kind_of? Hash
            @response = data.symbolize_keys!
            @response.each do |k,v|
              if @response[k] == "OpaqueRef:NULL"
                @response[k] = nil
              end
            end
          elsif data.kind_of? Array
            @response = data.first
          elsif data.kind_of?(String) and data =~ /OpaqueRef:/
            @response = data
          end

          @response
        end
      end
    end
  end
end
