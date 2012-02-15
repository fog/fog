module Fog
  module Parsers
    module Compute
      module Cloudstack

        class DeployVirtualMachine < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            case name
            when 'id'
              @response['id'] = value
            end
          end
        end
      end
    end
  end
end
