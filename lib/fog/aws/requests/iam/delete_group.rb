module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/basic'

        # Delete a group
        # 
        # ==== Parameters
        # * 'GroupName'<~String>: name of the group to delete
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        def delete_group(group_name)
          request(
            'Action'    => 'DeleteGroup',
            'GroupName' => group_name,
            :parser     => Fog::Parsers::AWS::IAM::Basic.new
          )
        end

      end

      class Mock

        def delete_group(group_name)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
