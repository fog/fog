module Fog
  module Parsers
    module AWS
      module EC2

        class CreateSnapshot < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'progress'
              @response[:progress] = @value
            when 'snapshotId'
              @response[:snapshot_id] = @value
            when 'startTime'
              @response[:start_time] = Time.parse(@value)
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