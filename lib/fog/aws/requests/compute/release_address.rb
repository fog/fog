module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Release an elastic IP address.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-ReleaseAddress.html]
        # 
        # non-VPC: requires public_ip only
        #     VPC: requires allocation_id only
        def release_address(ip_or_allocation)
          field = if ip_or_allocation.to_s =~ /^(\d|\.)+$/
                    "PublicIp"
                  else
                    "AllocationId"
                  end
          request(
            'Action'    => 'ReleaseAddress',
            field       => ip_or_allocation,
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::Basic.new
          )
        end

      end

      class Mock

        def release_address(public_ip)
          response = Excon::Response.new
          if (address = self.data[:addresses].delete(public_ip))
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return'    => true
            }
            response
          else
            raise Fog::Compute::AWS::Error.new("AuthFailure => The address '#{public_ip}' does not belong to you.")
          end
        end

      end
    end
  end
end
