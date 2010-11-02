module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/create_group'

        # Create a new group
        # 
        # ==== Parameters
        # * 'GroupName'<~String>: name of the group to create (do not include path)
        # * 'Path'<~String>: optional path to group, defaults to '/'
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Group'<~Hash>:
        #       * Arn<~String> -
        #       * GroupId<~String> -
        #       * GroupName<~String> -
        #       * Path<~String> -
        #     * 'RequestId'<~String> - Id of the request
        def create_group(group_name, path = '/')
          request(
            'Action'    => 'CreateGroup',
            'GroupName' => group_name,
            'Path'      => path,
            :parser     => Fog::Parsers::AWS::IAM::CreateGroups.new
          )
        end

      end

      class Mock

        def create_group(group_name, path = '/')
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
