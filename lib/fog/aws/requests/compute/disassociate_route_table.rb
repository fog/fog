module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/disassociate_route_table'

        # Disassociates a subnet from a route table.
        #
        # ==== Parameters
        # * AssociationId<~String> - The association ID representing the current association between the route table and subnet.
        # 
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - The ID of the request.
        #     * 'return'<~Boolean> - Returns true if the request succeeds. Otherwise, returns an error.
        #
        # {Amazon API Reference}[http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-DisassociateRouteTable.html]
        def disassociate_route_table(association_id)
          request(
            'Action'        => 'DisassociateRouteTable',
            'AssociationId' => association_id,
            :parser         => Fog::Parsers::Compute::AWS::DisassociateRouteTable.new
          )
        end

      end

      class Mock
        
      end
    end
  end
end
