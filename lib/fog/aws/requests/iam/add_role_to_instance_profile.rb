module Fog
  module AWS
    class IAM
      class Real
        require 'fog/aws/parsers/iam/basic'

        # Add a role to an instance profile
        #
        # ==== Parameters
        # * instance_profile_name<~String>: Name of the instance profile to update.
        # * role_name<~String>:Name of the role to add.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_AddRoleToInstanceProfile.html
        #
        def add_role_to_instance_profile(role_name, instance_profile_name)
          request(
            'Action'    => 'AddRoleToInstanceProfile',
            'InstanceProfileName' => instance_profile_name,
            'RoleName'  => role_name,
            :parser     => Fog::Parsers::AWS::IAM::Basic.new
          )
        end
      end
    end
  end
end
