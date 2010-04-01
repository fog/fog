module Fog
  module AWS
    module EC2
      class Real

        require 'fog/aws/parsers/ec2/attach_volume'

        # Attach an Amazon EBS volume with a running instance, exposing as specified device
        #
        # ==== Parameters
        # * instance_id<~String> - Id of instance to associate volume with
        # * volume_id<~String> - Id of amazon EBS volume to associate with instance
        # * device<~String> - Specifies how the device is exposed to the instance (e.g. "/dev/sdh")
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
        def attach_volume(instance_id, volume_id, device)
          request(
            'Action'      => 'AttachVolume',
            'VolumeId'    => volume_id,
            'InstanceId'  => instance_id,
            'Device'      => device,
            :parser       => Fog::Parsers::AWS::EC2::AttachVolume.new
          )
        end

      end

      class Mock

        def attach_volume(instance_id, volume_id, device)
          response = Excon::Response.new
          if instance_id && volume_id && device
            response.status = 200
            instance = @data[:instances][instance_id]
            volume = @data[:volumes][volume_id]
            if instance && volume
              data = {
                'attachTime'  => Time.now,
                'device'      => device,
                'instanceId'  => instance_id,
                'status'      => 'attaching',
                'volumeId'    => volume_id
              }
              volume['attachmentSet'] = [data]
              response.status = 200
              response.body = {
                'requestId' => Fog::AWS::Mock.request_id
              }.merge!(data)
            else
              response.status = 400
              raise(Excon::Errors.status_error({:expects => 200}, response))
            end
          else
            response.status = 400
            response.body = {
              'Code' => 'MissingParameter'
            }
            if !instance_id
              response['Message'] = 'The request must contain the parameter instance_id'
            elsif !volume_id
              response['Message'] = 'The request must contain the parameter volume_id'
            else
              response['Message'] = 'The request must contain the parameter device'
            end
          end
          response
        end

      end
    end
  end
end
