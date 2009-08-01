module Fog
  module AWS
    class EC2

      # Attach an Amazon EBS volume with a running instance, exposing as specified device
      #
      # ==== Parameters
      # * volume_id<~String> - Id of amazon EBS volume to associate with instance
      # * instance_id<~String> - Id of instance to associate volume with
      # * device<~String> - Specifies how the device is exposed to the instance (e.g. "/dev/sdh")
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
      def attach_volume(volume_id, instance_id, device)
        request({
          'Action' => 'AttachVolume',
          'VolumeId' => volume_id,
          'InstanceId' => instance_id,
          'Device' => device
        }, Fog::Parsers::AWS::EC2::AttachVolume.new)
      end

    end
  end
end