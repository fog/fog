module Fog
  module AWS
    module EC2
      class Real

        # Detach an Amazon EBS volume from a running instance
        #
        # ==== Parameters
        # * volume_id<~String> - Id of amazon EBS volume to associate with instance
        # * options<~Hash>:
        #   * 'Device'<~String> - Specifies how the device is exposed to the instance (e.g. "/dev/sdh")
        #   * 'Force'<~Boolean> - If true forces detach, can cause data loss/corruption
        #   * 'InstanceId'<~String> - Id of instance to associate volume with
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'attachTime'<~Time> - Time of attachment was initiated at
        #     * 'device'<~String> - Device as it is exposed to the instance
        #     * 'instanceId'<~String> - Id of instance for volume
        #     * 'requestId'<~String> - Id of request
        #     * 'status'<~String> - Status of volume
        #     * 'volumeId'<~String> - Reference to volume
        def detach_volume(volume_id, options = {})
          request({
            'Action'    => 'DetachVolume',
            'VolumeId'  => volume_id,
            :parser     => Fog::Parsers::AWS::EC2::DetachVolume.new
          }.merge!(options))
        end

      end

      class Mock

        def detach_volume(volume_id, options = {})
          response = Excon::Response.new
          response.status = 200
          if (volume = @data[:volumes][volume_id]) && !volume['attachmentSet'].empty?
            data = volume['attachmentSet'].pop
            volume['status'] = 'available'
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id
            }.merge!(data)
          else
            response.status = 400
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

      end
    end
  end
end
