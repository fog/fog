module Fog
  module AWS
    class IAM
      class Real
        require 'fog/aws/parsers/iam/list_instance_profiles'

        # Lists the instance profiles that have the specified associated role
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'Marker'<~String>: used to paginate subsequent requests
        #   * 'MaxItems'<~Integer>: limit results to this number per page
        # * 'RoleName'<~String>: The name of the role to list instance profiles for.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'InstanceProfiles'<~Array>:
        #       * instance_profile <~Hash>:
        #         * Arn<~String> -
        #         * CreateDate<~Date>
        #         * InstanceProfileId<~String> -
        #         * InstanceProfileName<~String> -
        #         * Path<~String> -
        #         * Roles<~Array> -
        #           role<~Hash>:
        #             * 'Arn'<~String> -
        #             * 'AssumeRolePolicyDocument'<~String<
        #             * 'Path'<~String> -
        #             *  'RoleId'<~String> -
        #             * 'RoleName'<~String> -
        #     * 'IsTruncated<~Boolean> - Whether or not results were truncated
        #     * 'Marker'<~String> - appears when IsTruncated is true as the next marker to use
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_ListInstanceProfilesForRole.html
        #
        def list_instance_profiles_for_role(role_name,options={})
          request({
            'Action'    => 'ListInstanceProfilesForRole',
            'RoleName'  => role_name,
            :parser     => Fog::Parsers::AWS::IAM::ListInstanceProfiles.new
          }.merge!(options))
        end
      end
    end
  end
end
