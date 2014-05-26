module Fog
  module AWS
    class IAM
      class Real
        require 'fog/aws/parsers/iam/basic'

        # removes a role from an instance profile
        #
        # Make sure you do not have any Amazon EC2 instances running with the role you are about to remove from the instance profile.
        # ==== Parameters
        # * instance_profile_name<~String>: Name of the instance profile to update.
        # * role_name<~String>:Name of the role to remove.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_RemoveRoleFromInstanceProfile.html
        #
        def remove_role_from_instance_profile(role_name, instance_profile_name)
          request(
            'Action'    => 'RemoveRoleFromInstanceProfile',
            'InstanceProfileName' => instance_profile_name,
            'RoleName'  => role_name,
            :parser     => Fog::Parsers::AWS::IAM::Basic.new
          )
        end
      end
    end
  end
end
