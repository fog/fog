require File.dirname(__FILE__) + '/basic'

module Fog
  module Parsers
    module AWS
      module EC2

        class CreateVolume < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'availabilityZone'
              @response[:availability_zone] = @value
            when 'createTime'
              @response[:create_time] = Time.parse(@value)
            when 'requestId'
              @response[:request_id] = @value
            when 'size'
              @response[:size] = @value.to_i
            when 'snapshotId'
              @response[:snapshot_id] = @value
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
