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
      #     * :volume_set<~Array>:
      #       * :volume_id<~String> - Reference to volume
      #       * :size<~Integer> - Size in GiBs for volume
      #       * :status<~String> - State of volume
      #       * :create_time<~Time> - Timestamp for creation
      #       * :availability_zone<~String> - Availability zone for volume
      #       * :snapshot_id<~String> - Snapshot volume was created from, if any
      #       * :attachment_set<~Array>:
      #         * :attachment_time<~Time> - Timestamp for attachment
      #         * :device<~String> - How value is exposed to instance
      #         * :instance_id<~String> - Reference to attached instance
      #         * :status<~String> - Attachment state
      #         * :volume_id<~String> - Reference to volume
      def describe_volumes(volume_ids = [])
        params = indexed_params('VolumeId', volume_ids)
        request({
          'Action' => 'DescribeVolumes'
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeVolumes.new)
      end

    end
  end
end
