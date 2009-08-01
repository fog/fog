module Fog
  module AWS
    class EC2

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
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'attachTime'<~Time> - Time of attachment was initiated at
      #     * 'device'<~String> - Device as it is exposed to the instance
      #     * 'instanceId'<~String> - Id of instance for volume
      #     * 'requestId'<~String> - Id of request
      #     * 'status'<~String> - Status of volume
      #     * 'volumeId'<~String> - Reference to volume
      def detach_volume(volume_id, options = {})
        request({
          'Action' => 'DetachVolume',
          'VolumeId' => volume_id
        }.merge!(options), Fog::Parsers::AWS::EC2::DetachVolume.new)
      end

    end
  end
end