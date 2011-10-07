module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/create_volume'

        # Create an EBS volume
        #
        # ==== Parameters
        # * availability_zone<~String> - availability zone to create volume in
        # * size<~Integer> - Size in GiBs for volume.  Must be between 1 and 1024.
        # * snapshot_id<~String> - Optional, snapshot to create volume from
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'availabilityZone'<~String> - Availability zone for volume
        #     * 'createTime'<~Time> - Timestamp for creation
        #     * 'size'<~Integer> - Size in GiBs for volume
        #     * 'snapshotId'<~String> - Snapshot volume was created from, if any
        #     * 'status's<~String> - State of volume
        #     * 'volumeId'<~String> - Reference to volume
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-CreateVolume.html]
        def create_volume(availability_zone, size, snapshot_id = nil)
          request(
            'Action'            => 'CreateVolume',
            'AvailabilityZone'  => availability_zone,
            'Size'              => size,
            'SnapshotId'        => snapshot_id,
            :parser             => Fog::Parsers::Compute::AWS::CreateVolume.new
          )
        end

      end

      class Mock

        def create_volume(availability_zone, size, snapshot_id = nil)
          response = Excon::Response.new
          if availability_zone && (size || snapshot_id)
            snapshot = self.data[:snapshots][snapshot_id]
            if snapshot_id && !snapshot
              raise Fog::Compute::AWS::NotFound.new("The snapshot '#{snapshot_id}' does not exist.")
            end

            if snapshot && size && size < snapshot['volumeSize']
              raise Fog::Compute::AWS::NotFound.new("The snapshot '#{snapshot_id}' has size #{snapshot['volumeSize']} which is greater than #{size}.")
            elsif snapshot && !size
              size = snapshot['volumeSize']
            end

            response.status = 200
            volume_id = Fog::AWS::Mock.volume_id
            data = {
              'availabilityZone'  => availability_zone,
              'attachmentSet'     => [],
              'createTime'        => Time.now,
              'size'              => size,
              'snapshotId'        => snapshot_id,
              'status'            => 'creating',
              'volumeId'          => volume_id
            }
            self.data[:volumes][volume_id] = data
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id
            }.merge!(data.reject {|key,value| !['availabilityZone','createTime','size','snapshotId','status','volumeId'].include?(key) })
          else
            response.status = 400
            response.body = {
              'Code' => 'MissingParameter'
            }
            unless availability_zone
              response.body['Message'] = 'The request must contain the parameter availability_zone'
            else
              response.body['Message'] = 'The request must contain the parameter size'
            end
          end
          response
        end

      end
    end
  end
end
