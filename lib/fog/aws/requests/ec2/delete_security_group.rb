unless Fog.mocking?

  module Fog
    module AWS
      class EC2

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
          request({
            'Action' => 'DeleteSecurityGroup',
            'GroupName' => name
          }, Fog::Parsers::AWS::EC2::Basic.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2
        def delete_security_group(name)
          response = Excon::Response.new
          if Fog::AWS::EC2.data[:security_groups][name]
            Fog::AWS::EC2.data[:security_groups].delete(name)
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
