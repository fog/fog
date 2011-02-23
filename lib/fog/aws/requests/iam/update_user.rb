module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/update_user'
        #require 'fog/aws/parsers/iam/basic'

        # Update an access key for a user
        # 
        # ==== Parameters
        # * user_name<~String> - Username to update
        # * options<~Hash>:
        #   * 'NewPath'<~String> - New path for the User. Include this only if you're changing the User's path.
        #   * 'NewUserName'<~String> - New name for the User. Include this only if you're changing the User's name.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/index.html?API_UpdateUser.html
        #
        def update_user(user_name, options = {})
          request({
            'UserName' => user_name,
            'Action'      => 'UpdateUser',
            :parser       => Fog::Parsers::AWS::IAM::UpdateUser.new
          }.merge!(options))
        end

      end
    end
  end
end
