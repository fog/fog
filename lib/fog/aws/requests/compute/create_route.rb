module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Creates a route table within a VPC.
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
        def create_route(route_table_id, destination_cidr_block, internet_gateway_id=nil, instance_id=nil)
          if internet_gateway_id
            request(
              'Action'                => 'CreateRoute',
              'RouteTableId'          => route_table_id,
              'GatewayId'     => internet_gateway_id,
              'DestinationCidrBlock'  => destination_cidr_block,
              :parser                 => Fog::Parsers::Compute::AWS::Basic.new
            )
          elsif instance_id
            request(
              'Action'                => 'CreateRoute',
              'RouteTableId'          => route_table_id,
              'InstanceId'            => instance_id,
              'DestinationCidrBlock'  => destination_cidr_block,              
              :parser                 => Fog::Parsers::Compute::AWS::Basic.new
            )
          end
        end

      end

      class Mock
        
      end
    end
  end
end
