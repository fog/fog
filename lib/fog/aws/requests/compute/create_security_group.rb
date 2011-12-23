module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Create a new security group
        #
        # ==== Parameters
        # * group_name<~String> - Name of the security group.
        # * group_description<~String> - Description of group.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-CreateSecurityGroup.html]
        def create_security_group(name, description, vpc_id=nil)
          request(
            'Action'            => 'CreateSecurityGroup',
            'GroupName'         => name,
            'GroupDescription'  => description,
            :parser             => Fog::Parsers::Compute::AWS::Basic.new,
            'VpcId'             => vpc_id
          )
        end

      end

      class Mock

        def create_security_group(name, description, vpc_id=nil)
          response = Excon::Response.new
          unless self.data[:security_groups][name]
            data = {
              'groupDescription'    => description,
              'groupName'           => name,
              'ipPermissionsEgress' => [],
              'ipPermissions'       => [],
              'ownerId'             => self.data[:owner_id],
              'vpcId'               => vpc_id
            }
            self.data[:security_groups][name] = data
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return'    => true
            }
            response
          else
            raise Fog::Compute::AWS::Error.new("InvalidGroup.Duplicate => The security group '#{name}' already exists")
          end
        end

      end
    end
  end
end
