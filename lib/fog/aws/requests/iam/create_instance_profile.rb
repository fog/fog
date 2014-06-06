module Fog
  module AWS
    class IAM
      class Real
        require 'fog/aws/parsers/iam/instance_profile'

        # Create a new instance_profile
        #
        # ==== Parameters
        # * instance_profile_name<~String>: name of the instance profile to create (do not include path)
        # * path<~String>: optional path to group, defaults to '/'
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'InstanceProfile'<~Hash>:
        #       * Arn<~String> -
        #       * CreateDate<~Date>
        #       * InstanceProfileId<~String> -
        #       * InstanceProfileName<~String> -
        #       * Path<~String> -
        #       * Roles<~Array> -
        #         role<~Hash>:
        #           * 'Arn'<~String> -
        #           * 'AssumeRolePolicyDocument'<~String<
        #           * 'Path'<~String> -
        #           * 'RoleId'<~String> -
        #           * 'RoleName'<~String> -
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_CreateInstanceProfile.html
        #
        def create_instance_profile(instance_profile_name, path='/', options={})
          request({
            'Action'    => 'CreateInstanceProfile',
            'InstanceProfileName' => instance_profile_name,
            'Path'      => path,
            :parser     => Fog::Parsers::AWS::IAM::InstanceProfile.new
          }.merge!(options))
        end
      end
    end
  end
end
