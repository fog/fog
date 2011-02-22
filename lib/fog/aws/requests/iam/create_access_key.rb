module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/create_access_key'

        # Create a access keys for user (by default detects user from access credentials)
        # 
        # ==== Parameters
        # * options<~Hash>:
        #   * 'UserName'<~String> - name of the user to create (do not include path)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'AccessKey'<~Hash>:
        #       * 'AccessKeyId'<~String> -
        #       * 'UserName'<~String> -
        #       * 'SecretAccessKey'<~String> -
        #       * 'Status'<~String> -
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_CreateAccessKey.html
        #
        def create_access_key(options = {})
          request({
            'Action'    => 'CreateAccessKey',
            :parser     => Fog::Parsers::AWS::IAM::CreateAccessKey.new
          }.merge!(options))
        end

      end
    end
  end
end
