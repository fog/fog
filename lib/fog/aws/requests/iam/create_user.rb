module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/create_user'

        # Create a new user
        # 
        # ==== Parameters
        # * user_name<~String>: name of the user to create (do not include path)
        # * path<~String>: optional path to group, defaults to '/'
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'User'<~Hash>:
        #       * 'Arn'<~String> -
        #       * 'Path'<~String> -
        #       * 'UserId'<~String> -
        #       * 'UserName'<~String> -
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_CreateUser.html
        #
        def create_user(user_name, path = '/')
          request(
            'Action'    => 'CreateUser',
            'UserName'  => user_name,
            'Path'      => path,
            :parser     => Fog::Parsers::AWS::IAM::CreateUser.new
          )
        end

      end

      class Mock
        def create_user(user_name, path='/')
          data[:users] ||= {}
          if data[:users].keys.include? user_name
            raise Fog::AWS::IAM::EntityAlreadyExists.new "User with name #{user_name} already exists."
          else
            response = Excon::Response.new
            user_resp = { "User"      => {
                                           "UserId"   => Fog::Mock.random_selection('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 21),
                                           "Path"     => path,
                                           "UserName" => user_name,
                                           "Arn"      => "arn:aws:iam::#{Fog::AWS::Mock.owner_id}:user/#{user_name}"
                                          },
                          "RequestId" => Fog::AWS::Mock.request_id
                        }

            data[:users][user_name] = user_resp
            response.status = 200
            response.body = user_resp
            response
          end
        end
      end
    end
  end
end
