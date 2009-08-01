module Fog
  module AWS
    class EC2
      
      # Describe all or specified snapshots
      #
      # ==== Parameters
      # * snapshot_id<~Array> - List of snapshots to describe, defaults to all
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'requestId'<~String> - Id of request
      #     * 'snapshotSet'<~Array>:
      #       * 'progress'<~String>: The percentage progress of the snapshot
      #       * 'snapshotId'<~String>: Id of the snapshot
      #       * 'startTime'<~Time>: Timestamp of when snapshot was initiated
      #       * 'status'<~String>: Snapshot state, in ['pending', 'completed']
      #       * 'volumeId'<~String>: Id of volume that snapshot contains
      def describe_snapshots(snapshot_id = [])
        params = indexed_params('SnapshotId', snapshot_id)
        request({
          'Action' => 'DescribeSnapshots'
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeSnapshots.new)
      end

    end
  end
end
