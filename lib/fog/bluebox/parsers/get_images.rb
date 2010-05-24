module Fog
  module Parsers
    module Bluebox

      class GetImages < Fog::Parsers::Base

        def reset
          @template = {}
          @response = { 'images' => [] }
        end

        def end_element(name)
          case name
          when 'public'
            @template[name] = @value
          when 'id'
            @template[name] = @value
          when 'description'
            @template[name] = @value
          when 'record'
            @response['images'] << @template
            @template = {}
          end
        end

      end

    end
  end
end
