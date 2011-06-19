module Fog
  module Parsers
    module Dynect
      module DNS

        class AnyRecord < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'zone', 'fqdn', 'record_type', 'record_id', 'rdata', 'address', 'txtdata'
              @response[name] = @value
            when 'ttl'
              @response[name] = @value.to_i
            end
          end

        end
      end
    end
  end
end
