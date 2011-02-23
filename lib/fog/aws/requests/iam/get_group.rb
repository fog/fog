module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/get_group'

        # Get Group
        # 
        # ==== Parameters        
        # * 'GroupName'<~String>: Name of the Group
        # * options<~Hash>:
        #   * 'Marker'<~String>: Use this only when paginating results, and only in a subsequent request after you've received a response where the results are truncated. Set it to the value of the Marker element in the response you just received.
        #   * 'MaxItems'<~String>: Use this only when paginating results to indicate the maximum number of User names you want in the response. If there are additional User names beyond the maximum you specify, the IsTruncated response element is true.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Group'<~Hash> - Group
        #       * 'Path'<~String>
        #       * 'GroupName'<~String>
        #       * 'Arn'<~String>
        #     * 'Users'<~Hash>? - List of users belonging to the group.
        #       * 'User'<~Hash> - User
        #         * Arn<~String> -
        #         * UserId<~String> -
        #         * UserName<~String> -
        #         * Path<~String> -
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/index.html?API_GetGroup.html
        #
        def get_group(group_name, options = {})
          request({
            'Action'    => 'GetGroup',
            'GroupName' => group_name,
            :parser     => Fog::Parsers::AWS::IAM::GetGroup.new
          }.merge!(options))
        end

      end
    end
  end
end
