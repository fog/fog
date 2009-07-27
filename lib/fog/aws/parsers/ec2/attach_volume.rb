module Fog
  module Parsers
    module AWS
      module EC2

        class AttachVolume < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'attachTime'
              @response[:attach_time] = Time.parse(@value)
            when 'device'
              @response[:device] = @value
            when 'instanceId'
              @response[:instance_id] = @value
            when 'requestId'
              @response[:request_id] = @value
            when 'status'
              @response[:status] = @value
            when 'volumeId'
              @response[:volume_id] = @value
            end
          end

        end

      end
    end
  end
end
