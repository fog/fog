module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Delete a security group that you own
        #
        # ==== Parameters
        # * group_name<~String> - Name of the security group.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DeleteSecurityGroup.html]
        def delete_security_group(name)
          request(
            'Action'    => 'DeleteSecurityGroup',
            'GroupName' => name,
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::Basic.new
          )
        end

      end

      class Mock
        def delete_security_group(name)
          response = Excon::Response.new
          if self.data[:security_groups][name]
            self.data[:security_groups].delete(name)
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return'    => true
            }
            response
          else
            raise Fog::Compute::AWS::NotFound.new("The security group '#{name}' does not exist")
          end
        end
      end
    end
  end
end
