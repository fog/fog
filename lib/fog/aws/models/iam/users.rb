require 'fog/core/collection'
require 'fog/aws/models/iam/user'

module Fog
  module AWS
    class IAM

      class Users < Fog::Collection

        model Fog::AWS::IAM::User

        def all
          data = connection.list_users.body['Users']
          load(data) # data is an array of attribute hashes
        end

        def get(identity)
          data = connection.get_user(identity).body['User']
          new(data) # data is an attribute hash
        rescue Fog::AWS::IAM::NotFound
          nil
        end

      end
    end
  end
end