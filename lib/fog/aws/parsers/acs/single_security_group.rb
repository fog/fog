module Fog
  module Parsers
    module AWS
      module ACS
        require 'fog/aws/parsers/acs/security_group_parser'

        class SingleSecurityGroup < SecurityGroupParser

          def reset
            super
            @response = { 'ResponseMetadata' => {} }
          end

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            case name
            when 'CacheSecurityGroup'
              @response[name] = @security_group
              reset_security_group

            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            else
              super
            end
          end
        end
      end
    end
  end
end
