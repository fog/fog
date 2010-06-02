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
          when 'record'
            @response['products'] << @product
            @product = {}
          when 'cost'
            @product[name] = @value.to_f
          when 'description', 'id'
            @product[name] = @value
          end
        end

      end

    end
  end
end
