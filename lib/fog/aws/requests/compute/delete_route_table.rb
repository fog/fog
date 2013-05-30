module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/delete_route_table'
        #Deletes a route table from your AWS account. The route table must not be associated with a subnet
        #
        # ==== Parameters
        # * route_table_id<~String> - The ID of the RouteTable you want to delete.
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of request
        # * 'return'<~Boolean> - Returns true if the request succeeds.
        #
        # {Amazon API Reference}[http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-DeleteRouteTable.html]
        def delete_route_table(route_table_id)
          request(
            'Action' => 'DeleteRouteTable',
            'RouteTableId' => route_table_id,
            :parser => Fog::Parsers::Compute::AWS::DeleteRouteTable.new
          )
        end
      end
      
      class Mock
        def delete_route_table(route_table_id)
          Excon::Response.new.tap do |response|
            if route_table_id
              response.status = 200
              self.data[:route_tables].reject! { |v| v['routeTableId'] == route_table_id }
            
              response.body = {
                'requestId' => Fog::AWS::Mock.request_id,
                'return' => true
              }
            else
              message = 'MissingParameter => '
              message << 'The request must contain the parameter route_table_id'
              raise Fog::Compute::AWS::Error.new(message)
            end
          end
        end
      end
    end
  end
end
