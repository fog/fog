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
        def create_acccess_key(options)
          #FIXME: Not 100% correct as AWS will use the signing credentials when there is no 'UserName' in the options hash
          #       Also doesn't raise an error when there are too many keys
          data[:users] ||= {}
          user_name = options['UserName']
          if data[:users].keys.include? user_name
            response = Excon::Response.new
            user_resp = { 'AccessKey' => { 'SecretAccessKey' => '',
                                           'Status' => 'Active',
                                           'AccessKeyId' => '',
                                           'UserName' => user_name
                                          },
                          'RequestId' => Fog::AWS::Mock.request_id }
            data[:users][user_name][:access_keys] ||= []
            data[:users][user_name][:access_keys] << user_resp
            response.status = 200
            response.body = user_resp
            response
          else
            raise Fog::AWS::IAM::NotFound.new('The user with name booboboboob cannot be found.')
          end
        end
      end
    end
  end
end
