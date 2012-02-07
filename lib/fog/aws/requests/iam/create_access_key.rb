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
      class Mock
        def create_access_key(options)
          #FIXME: Not 100% correct as AWS will use the signing credentials when there is no 'UserName' in the options hash
          #       Also doesn't raise an error when there are too many keys
          user_name = options['UserName']
          if data[:users].has_key? user_name
            key = { 'SecretAccessKey' => Fog::Mock.random_base64(40),
                    'Status' => 'Active',
                    'AccessKeyId' => Fog::AWS::Mock.key_id(20),
                    'UserName' => user_name
                  }

            data[:users][user_name][:access_keys] << key

            Excon::Response.new.tap do |response|
              response.status = 200
              response.body = { 'AccessKey' => key,
                                'RequestId' => Fog::AWS::Mock.request_id } 
            end
          else
            raise Fog::AWS::IAM::NotFound.new('The user with name booboboboob cannot be found.')
          end
        end
      end
    end
  end
end
