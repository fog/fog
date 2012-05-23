module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/detach_internet_gateway'
        # Detaches an Internet gateway to a VPC, enabling connectivity between the Internet and the VPC
        #
        # ==== Parameters
        # * internet_gateway_id<~String> - The ID of the Internet gateway to detach
        # * vpc_id<~String> - The ID of the VPC
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - Returns true if the request succeeds.
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DetachInternetGateway.html]
        def detach_internet_gateway(internet_gateway_id, vpc_id)
          request(
            'Action'               => 'DetachInternetGateway',
            'InternetGatewayId'    => internet_gateway_id,
            'VpcId'                => vpc_id,
            :idempotent   => true,
            :parser       => Fog::Parsers::Compute::AWS::DetachInternetGateway.new
          )
        end

      end

      class Mock

        def detach_internet_gateway(internet_gateway_id, vpc_id)
          response = Excon::Response.new
          if internet_gateway_id && vpc_id
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return' => true
            }
            response
          else
            if !internet_gateway_id
              message << 'The request must contain the parameter internet_gateway_id'
            elsif !vpc_id
              message << 'The request must contain the parameter vpc_id'
            end
            raise Fog::Compute::AWS::Error.new(message)
          end
        end

      end
    end
  end
end
