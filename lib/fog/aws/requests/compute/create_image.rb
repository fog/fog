module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/create_image'

        # Create a bootable EBS volume AMI
        #
        # ==== Parameters
        # * instance_id<~String> - Instance used to create image.
        # * name<~Name> - Name to give image.
        # * description<~Name> - Description of image.
        # * no_reboot<~Boolean> - Optional, whether or not to reboot the image when making the snapshot
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'imageId'<~String> - The ID of the created AMI.
        #     * 'requestId'<~String> - Id of request.
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-CreateImage.html]
        def create_image(instance_id, name, description, no_reboot = false, attributes=[])
          params = {}
          attributes.each{|attr|
            params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.DeviceName', attr['DeviceName']))
            params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.NoDevice', attr['NoDevice']))
            params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.VirtualName', attr['VirtualName']))
            params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.Ebs.SnapshotId', attr['Ebs.SnapshotId']))
            params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.Ebs.DeleteOnTermination', attr['Ebs.DeleteOnTermination']))
            params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.Ebs.VolumeType', attr['Ebs.VolumeType']))
            params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.Ebs.Iops', attr['Ebs.Iops']))
          }
          request({
            'Action'            => 'CreateImage',
            'InstanceId'        => instance_id,
            'Name'              => name,
            'Description'       => description,
            'NoReboot'          => no_reboot.to_s,
            :parser             => Fog::Parsers::Compute::AWS::CreateImage.new
          }.merge!(params))
        end
      end

      class Mock
        
        # Usage
        # 
        # AWS[:compute].create_image("i-ac65ee8c", "test", "something")
        #
        
        def create_image(instance_id, name, description, no_reboot = false, attributes = {})
          params = {}
          params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.DeviceName', attributes['DeviceName']))
          params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.NoDevice', attributes['NoDevice']))
          params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.VirtualName', attributes['VirtualName']))
          params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.Ebs.SnapshotId', attributes['Ebs.SnapshotId']))
          params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.Ebs.DeleteOnTermination', attributes['Ebs.DeleteOnTermination']))
          params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.Ebs.VolumeType', attributes['Ebs.VolumeType']))
          params.merge!(Fog::AWS.indexed_param('BlockDeviceMapping.%d.Ebs.Iops', attributes['Ebs.Iops']))
          response = Excon::Response.new
          if instance_id && !name.empty?
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'imageId' => Fog::AWS::Mock.image_id
            }
          else
            response.status = 400
            response.body = {
              'Code' => 'InvalidParameterValue'
            }
            if name.empty?
              response.body['Message'] = "Invalid value '' for name. Must be specified."
            end
          end
          response
        end

      end
    end
  end
end
