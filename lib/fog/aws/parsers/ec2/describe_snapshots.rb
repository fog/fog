require File.dirname(__FILE__) + '/basic'

module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeSnapshots < Fog::Parsers::Base

          def reset
            @response = { :snapshot_set => [] }
            @snapshot = {}
          end

          def end_element(name)
            case name
            when 'item'
              @response[:snapshot_set] << @snapshot
              @snapshot = {}
            when 'progress'
              @snapshot[:progress] = @value
            when 'snapshotId'
              @snapshot[:snapshot_id] = @value
            when 'startTime'
              @snapshot[:start_time] = Time.parse(@value)
            when 'status'
              @snapshot[:status] = @value
            when 'volumeId'
              @snapshot[:volume_id] = @value
            end
          end

        end

      end
    end
  end
end
