unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Create a new security group
        #
        # ==== Parameters
        # * group_name<~String> - Name of the security group.
        # * group_description<~String> - Description of group.
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        def create_security_group(name, description)
          request({
            'Action' => 'CreateSecurityGroup',
            'GroupName' => name,
            'GroupDescription' => CGI.escape(description)
          }, Fog::Parsers::AWS::EC2::Basic.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def create_security_group(name, description)
          response = Fog::Response.new
          unless Fog::AWS::EC2.data[:security_groups][name]
            data = {
              'GroupDescription'  => description,
              'GroupName'         => name,
              'ipPermissions'     => [],
              'OwnerId'           => Fog::AWS::Mock.owner_id
            }
            Fog::AWS::EC2.data[:security_groups][name] = data
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return'    => true
            }
          else
            response.status = 400
            raise(Fog::Errors.status_error(200, 400, response))
          end
          response
        end

      end
    end
  end

end
