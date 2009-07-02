require File.dirname(__FILE__) + '/../../parser'

module Fog
  module Parsers
    module AWS
      module EC2

        class AllocateAddress < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'requestId'
              @response[:request_id] = @value
            when 'publicIp'
              @response[:public_ip] = @value
            end
          end

        end

        class DescribeAddresses < Fog::Parsers::Base

          def reset
            @address = {}
            @response = { :addresses => [] }
          end

          def end_element(name)
            case name
            when 'instanceId'
              @address[:instance_id] = @value
            when 'item'
              @response[:addresses] << @address
              @address = []
            when 'publicIp'
              @address[:public_ip] = @value
            when 'requestId'
              @response[:request_id] = @value
            end
          end

        end

        class ReleaseAddress < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'requestId'
              @response[:request_id] = @value
            when 'return'
              if @value == 'true'
                @response[:return] = true
              else
                @response[:return] = false
              end
            end
          end

        end

      end
    end
  end
end