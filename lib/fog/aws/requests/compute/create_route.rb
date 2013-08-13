module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Creates a route in a route table within a VPC.
        #
        # ==== Parameters
        # * RouteTableId<~String> - The ID of the route table for the route.
        # * DestinationCidrBlock<~String> - The CIDR address block used for the destination match. Routing decisions are based on the most specific match.
        # * GatewayId<~String> - The ID of an Internet gateway attached to your VPC.
        # * InstanceId<~String> - he ID of a NAT instance in your VPC. The operation fails if you specify an instance ID unless exactly one network interface is attached.
        # * NetworkInterfaceId<~String> - The ID of a network interface.
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of the request
        # * 'return'<~Boolean> - Returns true if the request succeeds. Otherwise, returns an error.
        #
        # {Amazon API Reference}[http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-CreateRoute.html]
        def create_route(route_table_id, destination_cidr_block, internet_gateway_id=nil, instance_id=nil, network_interface_id=nil)
          request_vars = {
            'Action'                => 'CreateRoute',
            'RouteTableId'          => route_table_id,
            'DestinationCidrBlock'  => destination_cidr_block,
            :parser                 => Fog::Parsers::Compute::AWS::Basic.new
          }
          if internet_gateway_id
            request_vars['GatewayId'] = internet_gateway_id
          elsif instance_id
            request_vars['InstanceId'] = instance_id
          elsif network_interface_id
            request_vars['NetworkInterfaceId'] = network_interface_id         
          end
          request(request_vars)
        end
      end

      class Mock

        def create_route(route_table_id, destination_cidr_block, internet_gateway_id=nil, instance_id=nil, network_interface_id=nil)

        end        
      end
    end
  end
end
