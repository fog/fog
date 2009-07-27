module Fog
  module AWS
    class EC2

      # Detach an Amazon EBS volume from a running instance
      #
      # ==== Parameters
      # * volume_id<~String> - Id of amazon EBS volume to associate with instance
      # * options<~Hash>:
      #   * device<~String> - Specifies how the device is exposed to the instance (e.g. "/dev/sdh")
      #   * force<~Boolean> - If true forces detach, can cause data loss/corruption
      #   * instance_id<~String> - Id of instance to associate volume with
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :attach_time<~Time> - Time of attachment was initiated at
      #     * :device<~String> - Device as it is exposed to the instance
      #     * :instance_id<~String> - Id of instance for volume
      #     * :request_id<~String> - Id of request
      #     * :status<~String> - Status of volume
      #     * :volume_id<~String> - Reference to volume
      def detach_volume(volume_id, options = {})
        request({
          'Action' => 'DetachVolume',
          'VolumeId' => volume_id,
          'Force' => options[:force].nil? ? nil : options[:force].to_s,
          'InstanceId' => options[:instance_id],
          'Device' => options[:device]
        }, Fog::Parsers::AWS::EC2::DetachVolume.new)
      end

    end
  end
end