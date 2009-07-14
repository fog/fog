module Fog
  module AWS
    class EC2

      # Delete a snapshot of an EBS volume that you own
      #
      # ==== Parameters
      # * snapshot_id<~String> - ID of snapshot to delete
      # ==== Returns
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :request_id<~String> - Id of request
      #     * :return<~Boolean> - success?
      def delete_snapshot(snapshot_id)
        request({
          'Action' => 'DeleteSnapshot',
          'SnapshotId' => snapshot_id
        }, Fog::Parsers::AWS::EC2::Basic.new)
      end

    end
  end
end
