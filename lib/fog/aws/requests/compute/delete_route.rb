module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'


        def delete_route(route_table_id, destination_cidr_block)
          request(
            'Action'                => 'DeleteRoute',
            'RouteTableId'          => route_table_id,
            'DestinationCidrBlock'  => destination_cidr_block,              
            :parser                 => Fog::Parsers::Compute::AWS::Basic.new
          )
        end

      end

      class Mock
        
      end
    end
  end
end
