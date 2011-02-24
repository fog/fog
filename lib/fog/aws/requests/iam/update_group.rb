module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/update_group'

        # Update a Group
        #
        # ==== Parameters
        # * group_name<~String> - Required. Name of the Group to update. If you're changing the name of the Group, this is the original Group name.
        # * options<~Hash>:
        #   * new_path<~String> - New path for the Group. Include this parameter only if you're changing the Group's path.
        #   * new_group_name<~String> - New name for the Group. Include this parameter only if you're changing the Group's name.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #     * 'Group'<~Hash> - Changed Group info
        #       * 'Arn'<~String> -
        #       * 'Path'<~String> -
        #       * 'GroupId'<~String> -
        #       * 'GroupName'<~String> -
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/index.html?API_UpdateGroup.html
        #
        def update_group(group_name, options = {})
          request({
            'Action'      => 'UpdateGroup',
            'GroupName'    => group_name,
            :parser       => Fog::Parsers::AWS::IAM::UpdateGroup.new
          }.merge!(options))
        end

      end
    end
  end
end
