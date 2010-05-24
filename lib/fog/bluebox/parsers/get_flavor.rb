# Response formet:
# <hash>
#   <cost type="decimal">0.15</cost>
#   <id>94fd37a7-2606-47f7-84d5-9000deda52ae</id>
#   <description>Block 1GB Virtual Server</description>
# </hash>

module Fog
  module Parsers
    module Bluebox

      class GetFlavor < Fog::Parsers::Base

        def reset
          @response = {}
        end

        def end_element(name)
          case name
          when 'hash'
            # Do nothing
          when 'cost'
            @response[name] = @value.to_f
          else
            @response[name] = @value
          end
        end

      end

    end
  end
end
