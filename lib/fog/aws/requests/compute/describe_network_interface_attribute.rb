module Fog
  module Compute
    class AWS
      class Real
        require 'fog/aws/parsers/compute/describe_network_interface_attribute'
        # Describes a network interface attribute value
        #
        # ==== Parameters
        # * network_interface_id<~String> - The ID of the network interface you want to describe an attribute of
        # * attribute<~String>            - The attribute to describe, must be one of 'description', 'groupSet', 'sourceDestCheck' or 'attachment'
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of request
        # * 'networkInterfaceId'<~String> - The ID of the network interface
        # * 'description'<~String>        - The description (if requested)
        # * 'groupSet'<~Hash>             - Associated security groups (if requested)
        # *   'key'<~String>              - ID of associated group
        # *   'value'<~String>            - Name of associated group
        # * 'sourceDestCheck'<~Boolean>   - Flag indicating whether traffic to or from the instance is validated (if requested)
        # * 'attachment'<~Hash>:          - Describes the way this nic is attached  (if requested)
        # *   'attachmentID'<~String>
        # *   'instanceID'<~String>
        # *   'instanceOwnerId'<~String>
        # *   'deviceIndex'<~Integer>
        # *   'status'<~String>
        # *   'attachTime'<~String>
        # *   'deleteOnTermination<~Boolean>
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/2012-03-01/APIReference/ApiReference-query-DescribeNetworkInterfaceAttribute.html]
        def describe_network_interface_attribute(network_interface_id, attribute)
          request(
            'Action'             => 'DescribeNetworkInterfaceAttribute',
            'NetworkInterfaceId' => network_interface_id,
            'Attribute'          => attribute,
            :parser              => Fog::Parsers::Compute::AWS::DescribeNetworkInterfaceAttribute.new
          )
        end
      end

      class Mock
        def describe_network_interface_attribute(network_interface_id, attribute)
          response = Excon::Response.new
          if self.data[:network_interfaces][network_interface_id]

            response.status = 200
            response.body = {
              'requestId'          => Fog::AWS::Mock.request_id,
              'networkInterfaceId' => network_interface_id
            }
            case attribute
            when 'description', 'groupSet', 'sourceDestCheck', 'attachment'
              response.body[attribute] = self.data[:network_interfaces][network_interface_id][attribute]
            else
              raise Fog::Compute::AWS::Error.new("Illegal attribute '#{attribute}' specified")
            end
            response
          else
            raise Fog::Compute::AWS::NotFound.new("The network interface '#{network_interface_id}' does not exist")
          end
        end
      end
    end
  end
end
