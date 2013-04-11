module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'


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
