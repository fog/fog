module Fog
  module Parsers
    module Compute
      module Cloudstack

        class RegisterSshKeyPair < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            @response[name] = value
          end

        end
      end
    end
  end
end
