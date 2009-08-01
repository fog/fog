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
            when 'progress', 'snapshotId', 'status', 'volumeId'
              @snapshot[name] = @value
            when 'startTime'
              @snapshot[name] = Time.parse(@value)
            end
          end

        end

      end
    end
  end
end
