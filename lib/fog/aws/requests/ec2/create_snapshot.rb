unless Fog.mocking?

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
        #     * 'progress'<~String> - The percentage progress of the snapshot
        #     * 'requestId'<~String> - id of request
        #     * 'snapshotId'<~String> - id of snapshot
        #     * 'startTime'<~Time> - timestamp when snapshot was initiated
        #     * 'status'<~String> - state of snapshot
        #     * 'volumeId'<~String> - id of volume snapshot targets
        def create_snapshot(volume_id)
          request({
            'Action' => 'CreateSnapshot',
            'VolumeId' => volume_id
          }, Fog::Parsers::AWS::EC2::CreateSnapshot.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def create_snapshot(volume_id)
          response = Fog::Response.new
          if Fog::AWS::EC2.data[:volumes][volume_id]
            response.status = 200
            snapshot_id = Fog::AWS::Mock.snapshot_id
            data = {
              'progress'    => '',
              'snapshotId'  => snapshot_id,
              'startTime'   => Time.now,
              'status'      => 'pending',
              'volumeId'    => volume_id
            }
            Fog::AWS::EC2.data[:snapshots][snapshot_id] = data
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id
            }.merge!(data)
          else
            response.status = 400
            raise(Fog::Errors.status_error(200, 400, response))
          end
          response
        end

      end
    end
  end

end
