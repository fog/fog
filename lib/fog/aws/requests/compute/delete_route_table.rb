module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Delete an EBS volume
        #
        # ==== Parameters
        # * volume_id<~String> - Id of volume to delete.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DeleteVolume.html]
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
