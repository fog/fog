module Fog
  module Parsers
    module Bluebox

      class GetBlocks < Fog::Parsers::Base

        def reset
          @block = {}
          @response = { 'blocks' => [] }
        end

        def end_element(name)
          case name
          when 'ip'
            @block['ips'] ||= []
            @block['ips'] << @value
          when 'memory', 'storage'
            @block[name] = @value.to_i
          when 'cpu'
            @block[name] = @value.to_f
          when 'hostname', 'id'
            @block[name] = @value
          when 'record'
            @response['blocks'] << @block
            @block = {}
          end
        end

      end

    end
  end
end
