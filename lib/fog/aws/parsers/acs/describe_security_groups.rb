module Fog
  module Parsers
    module AWS
      module ACS
        require 'fog/aws/parsers/acs/security_group_parser'

        class DescribeSecurityGroups < SecurityGroupParser

          def reset
            super
            @response['CacheSecurityGroups'] = []
          end

          def end_element(name)
            case name
            when 'CacheSecurityGroup'
              @response["#{name}s"] << @security_group
              reset_security_group
            else
              super
            end
          end
        end
      end
    end
  end
end
