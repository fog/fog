module Fog
  module AWS
    class EC2

      # Create a snapshot of an EBS volume and store it in S3
      #
      # ==== Parameters
      # * volume_id<~String> - Id of EBS volume to snapshot
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :progress<~String> - The percentage progress of the snapshot
      #     * :request_id<~String> - id of request
      #     * :snapshot_id<~String> - id of snapshot
      #     * :start_time<~Time> - timestamp when snapshot was initiated
      #     * :status<~String> - state of snapshot
      #     * :volume_id<~String> - id of volume snapshot targets
      def create_snapshot(volume_id)
        request({
          'Action' => 'CreateSnapshot',
          'VolumeId' => volume_id
        }, Fog::Parsers::AWS::EC2::CreateSnapshot.new)
      end

    end
  end
end
