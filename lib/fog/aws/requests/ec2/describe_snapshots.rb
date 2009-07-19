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
      #     * :request_id<~String> - Id of request
      #     * :snapshot_set<~Array>:
      #       * :progress<~String>: The percentage progress of the snapshot
      #       * :snapshot_id<~String>: Id of the snapshot
      #       * :start_time<~Time>: Timestamp of when snapshot was initiated
      #       * :status<~String>: Snapshot state, in ['pending', 'completed']
      #       * :volume_id<~String>: Id of volume that snapshot contains
      def describe_snapshots(snapshot_id = [])
        params = indexed_params('SnapshotId', snapshot_id)
        request({
          'Action' => 'DescribeSnapshots'
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeSnapshots.new)
      end

    end
  end
end
