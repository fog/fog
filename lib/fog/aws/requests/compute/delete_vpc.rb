module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Deletes a VPC. You must detach or delete all gateways or other objects
        # that are dependent on the VPC first. For example, you must terminate
        # all running instances, delete all VPC security groups (except the
        # default), delete all the route tables (except the default), etc.
        #
        # ==== Parameters
        # * vpc_id<~String> - The ID of the VPC you want to delete.
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of request
        # * 'return'<~Boolean> - Returns true if the request succeeds.
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/2011-07-15/APIReference/index.html?ApiReference-query-DeleteVpc.html]
        def delete_vpc(vpc_id)
          request(
            'Action' => 'DeleteVpc',
            'VpcId' => vpc_id,
            :parser => Fog::Parsers::Compute::AWS::Basic.new
          )
        end
      end
      
      class Mock
        def delete_vpc(vpc_id)
          Excon::Response.new.tap do |response|
            if vpc_id
              response.status = 200
              self.data[:vpcs].reject! { |v| v['vpcId'] == vpc_id }

              response.body = {
                'requestId' => Fog::AWS::Mock.request_id,
                'return' => true
              }
            else
              message = 'MissingParameter => '
              message << 'The request must contain the parameter vpc_id'
              raise Fog::Compute::AWS::Error.new(message)
            end
          end
        end
      end
    end
  end
end
