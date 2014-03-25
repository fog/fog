module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/attach_network_interface'

        # Attach a network interface
        #
        # ==== Parameters
        # * networkInterfaceId<~String> - ID of the network interface to attach
        # * instanceId<~String>         - ID of the instance that will be attached to the network interface
        # * deviceIndex<~Integer>       - index of the device for the network interface attachment on the instance
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String>    - Id of request
        # * 'attachmentId'<~String> - ID of the attachment
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/2012-03-01/APIReference/index.html?ApiReference-query-AttachNetworkInterface.html]
        def attach_network_interface(nic_id, instance_id, device_index)
          request(
            'Action' => 'AttachNetworkInterface',
            'NetworkInterfaceId' => nic_id,
            'InstanceId'         => instance_id,
            'DeviceIndex'        => device_index,
            :parser => Fog::Parsers::Compute::AWS::AttachNetworkInterface.new
          )
        end
      end


      class Mock

        def attach_network_interface(nic_id, instance_id, device_index)
          response = Excon::Response.new
          if self.data[:network_interfaces][nic_id]
            attachment = self.data[:network_interfaces][nic_id]['attachment']
            attachment['attachmentId'] = Fog::AWS::Mock.request_id
            attachment['instanceId']   = instance_id

            response.status = 200
            response.body = {
              'requestId'    => Fog::AWS::Mock.request_id,
              'attachmentId' => attachment['attachmentId']
            }
          else
            raise Fog::Compute::AWS::NotFound.new("The network interface '#{nic_id}' does not exist")
          end

          response
        end
      end
    end
  end
end
