module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Deletes the specified route table.
        #
        # ==== Parameters
        # * RouteTableId<~String> - The ID of the route table.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - The ID of request.
        #     * 'return'<~Boolean> - Returns true if the request succeeds. Otherwise, returns an error.
        #
        # {Amazon API Reference}[http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-DeleteRouteTable.html]
        def delete_route_table(route_table_id)
          request(
            'Action'    => 'DeleteRouteTable',
            'RouteTableId'  => route_table_id,
            :parser     => Fog::Parsers::Compute::AWS::Basic.new
          )
        end

      end

      class Mock

      end
    end
  end
end
