module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/basic'

        # Delete an access key
        # 
        # ==== Parameters
        # * access_key_id<~String> - Access key id to delete
        # * user_name<~String> - optional: name of the user to delete access key from
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_DeleteAccessKey.html
        #
        def delete_access_key(access_key_id, user_name = nil)
          params = {
            'AccessKeyId' => access_key_id,
            'Action'      => 'DeleteUser',
            :parser       => Fog::Parsers::AWS::IAM::Basic.new
          }
          if user_name
            params['UserName'] = user_name
          end
          request(params)
        end

      end

      class Mock

        def delete_access_key(access_key_id, user_name = nil)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
