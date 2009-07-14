module Fog
  module AWS
    class EC2
      
      # Describe all or specified snapshots
      #
      # ==== Parameters
      # * snapshot_id<~Array> - List of snapshots to describe, defaults to all
      #
      # ==== Returns
      # FIXME: docs
      def describe_snapshots(snapshot_id = [])
        params = indexed_params('SnapshotId', snapshot_id)
        request({
          'Action' => 'DescribeSnapshots'
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeSnapshots.new)
      end

    end
  end
end
