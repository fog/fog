module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/detach_volume'

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
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DetachVolume.html]
        def detach_volume(volume_id, options = {})
          request({
            'Action'    => 'DetachVolume',
            'VolumeId'  => volume_id,
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::DetachVolume.new
          }.merge!(options))
        end

      end

      class Mock

        def detach_volume(volume_id, options = {})
          response = Excon::Response.new
          response.status = 200
          if (volume = self.data[:volumes][volume_id]) && !volume['attachmentSet'].empty?
            data = volume['attachmentSet'].pop
            volume['status'] = 'available'
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id
            }.merge!(data)
            response
          else
            raise Fog::Compute::AWS::NotFound.new("The volume '#{volume_id}' does not exist.")
          end
        end

      end
    end
  end
end
