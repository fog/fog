module Fog
  module Parsers
    module Dynect
      module DNS

        class Zone < Fog::Parsers::Base

          def reset
            @response = {"zones" => []}
          end

          def end_element(name)
            case name
            when 'ZoneURI'
              @response['zones'] << @value.match(/\/REST\/Zone\/(.+)\//)[1]
            end
          end

        end
      end
    end
  end
end
