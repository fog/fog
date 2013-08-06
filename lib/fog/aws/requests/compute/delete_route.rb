module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Deletes the specified route from the specified route table. 
        #
        # ==== Parameters
        # * RouteTableId<~String> - The ID of the route table.
        # * DestinationCidrBlock<~String> - The CIDR range for the route. The value you specify must match the CIDR for the route exactly.
        # 
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - The ID of the request.
        #     * 'return'<~Boolean> - Returns true if the request succeeds. Otherwise, returns an error.
        #
        # {Amazon API Reference}[http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-DeleteRoute.html]
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
