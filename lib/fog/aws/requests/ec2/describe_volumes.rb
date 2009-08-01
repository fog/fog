module Fog
  module AWS
    class EC2

      # Describe all or specified volumes.
      #
      # ==== Parameters
      # * volume_ids<~Array> - List of volumes to describe, defaults to all
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'volumeSet'<~Array>:
      #       * 'volumeId'<~String> - Reference to volume
      #       * 'size'<~Integer> - Size in GiBs for volume
      #       * 'status'<~String> - State of volume
      #       * 'createTime'<~Time> - Timestamp for creation
      #       * 'availabilityZone'<~String> - Availability zone for volume
      #       * 'snapshotId'<~String> - Snapshot volume was created from, if any
      #       * 'attachmentSet'<~Array>:
      #         * 'attachmentTime'<~Time> - Timestamp for attachment
      #         * 'device'<~String> - How value is exposed to instance
      #         * 'instanceId'<~String> - Reference to attached instance
      #         * 'status'<~String> - Attachment state
      #         * 'volumeId'<~String> - Reference to volume
      def describe_volumes(volume_ids = [])
        params = indexed_params('VolumeId', volume_ids)
        request({
          'Action' => 'DescribeVolumes'
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeVolumes.new)
      end

    end
  end
end
