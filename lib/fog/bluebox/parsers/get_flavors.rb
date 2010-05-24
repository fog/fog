module Fog
  module Parsers
    module Bluebox

      class GetFlavors < Fog::Parsers::Base

        def reset
          @product = {}
          @response = { 'flavors' => [] }
        end

        def end_element(name)
          case name
          when 'record'
            @response['flavors'] << @product
            @product = {}
          when 'cost'
            @product[name] = @value.to_f
          else
            @product[name] = @value
          end
        end

      end

    end
  end
end
