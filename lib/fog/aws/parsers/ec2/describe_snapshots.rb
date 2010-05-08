module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeSnapshots < Fog::Parsers::Base

          def reset
            @response = { 'snapshotSet' => [] }
            @snapshot = {}
          end

          def end_element(name)
            case name
            when 'item'
              @response['snapshotSet'] << @snapshot
              @snapshot = {}
            when 'description', 'ownerId', 'progress', 'snapshotId', 'status', 'volumeId'
              @snapshot[name] = @value
            when 'requestId'
              @response[name] = @value
            when 'startTime'
              @snapshot[name] = Time.parse(@value)
            when 'volumeSize'
              @snapshot[name] = @value.to_i
            end
          end

        end

      end
    end
  end
end
