module Fog
  module Parsers
    module Bluebox

      class GetTemplates < Fog::Parsers::Base

        def reset
          @template = {}
          @response = { 'templates' => [] }
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
            @response['templates'] << @template
            @template = {}
          end
        end

      end

    end
  end
end
