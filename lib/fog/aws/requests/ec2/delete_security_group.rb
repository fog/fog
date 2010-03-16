module Fog
  module AWS
    module EC2
      class Real

        require 'fog/aws/parsers/ec2/basic'

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
        def delete_security_group(name)
          request(
            'Action'    => 'DeleteSecurityGroup',
            'GroupName' => name,
            :parser     => Fog::Parsers::AWS::EC2::Basic.new
          )
        end

      end

      class Mock
        def delete_security_group(name)
          response = Excon::Response.new
          if @data[:security_groups][name]
            @data[:security_groups].delete(name)
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return'    => true
            }
          else
            response.status = 400
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end
      end
    end
  end
end
