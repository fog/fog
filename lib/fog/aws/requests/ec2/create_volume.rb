unless Fog.mocking?

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
        #     * 'size'<~Integer> - Size in GiBs for volume
        #     * 'snapshotId'<~String> - Snapshot volume was created from, if any
        #     * 'status's<~String> - State of volume
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

else

  module Fog
    module AWS
      class EC2

        def create_volume(availability_zone, size, snapshot_id = nil)
          response = Fog::Response.new
          response.status = 200
          volume_id = Fog::AWS::Mock.volume_id
          data = {
            'availabilityZone'  => availability_zone,
            'attachmentSet'     => [],
            'createTime'        => Time.now,
            'size'              => size,
            'snapshotId'        => snapshot_id || '',
            'status'            => 'creating',
            'volumeId'          => volume_id
          }
          Fog::AWS::EC2.data[:volumes][volume_id] = data
          response.body = {
            'requestId' => Fog::AWS::Mock.request_id
          }.merge!(data.reject {|key,value| !['availabilityZone','createTime','size','snapshotId','status','volumeId'].include?(key) })
          response
        end

      end
    end
  end

end
