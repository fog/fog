module Fog
  module AWS
    class EC2

      # Create an EBS volume
      #
      # ==== Parameters
      # * availability_zone<~String> - availability zone to create volume in
      # * size<~Integer> - Size in GiBs for volume.  Must be between 1 and 1024.
      # * snapshot_id<~String> - Optional, snapshot to create volume from
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'availabilityZone'<~String> - Availability zone for volume
      #     * 'createTime'<~Time> - Timestamp for creation
      #     * 'requestId'<~String> - Id of request
      #     * 'size'<~Integer> - Size in GiBs for volume
      #     * 'snapshotId'<~String> - Snapshot volume was created from, if any
      #     * 'status'<~String> - State of volume
      #     * 'volumeId'<~String> - Reference to volume
      def create_volume(availability_zone, size, snapshot_id = nil)
        request({
          'Action' => 'CreateVolume',
          'AvailabilityZone' => availability_zone,
          'Size' => size,
          'SnapshotId' => snapshot_id
        }, Fog::Parsers::AWS::EC2::CreateVolume.new)
      end

    end
  end
end