module Fog
  module Parsers
    module Bluebox

      class GetProducts < Fog::Parsers::Base

        def reset
          @product = {}
          @response = { 'products' => [] }
        end

        def end_element(name)
          case name
          when 'cost'
            @product[name] = @value
          when 'id'
            @product[name] = @value
          when 'description'
            @product[name] = @value
          when 'record'
            @response['products'] << @product
            @product = {}
          end
        end

      end

    end
  end
end
