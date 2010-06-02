module Fog
  module Parsers
    module Bluebox

      class CreateBlock < Fog::Parsers::Base

        def reset
          @response = {}
        end

        def end_element(name)
          case name
          when 'address'
            @response['ips'] ||= []
            @response['ips'] << @value
          when 'memory', 'storage'
            @response[name] = @value.to_i
          when 'cpu'
            @response[name] = @value.to_f
          when 'id'
            if @scope == 'product'
              @response['flavor_id'] = @value
            else
              @response[name] = @value
            end
          when 'name', 'hostname', 'status', 'text', 'hash'
            @response[name] = @value
          when 'template'
            @response['image_id'] = @value
          when 'product'
            @scope = nil
          end
        end

        def start_element(name, attrs=[])
          super
          case name
          when 'product'
            @scope = name
          end
        end
      end
    end
  end
end
