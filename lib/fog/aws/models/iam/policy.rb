require 'fog/core/model'

module Fog
  module AWS
    class IAM

      class Policy < Fog::Model

        identity  :id, :aliases => 'PolicyName'
        attribute :username, :aliases => 'UserName'
        attribute :document, :aliases => 'PolicyDocument'

        def save
          requires :id
          requires :username
          requires :document

          data = service.put_user_policy(username, id, document).body
          merge_attributes(data)
          true
        end

        def destroy
          requires :id
          requires :username

          service.delete_user_policy(username, id)
          true
        end

        def user
          requires :username
          service.users.get(username)
        end

      end
    end
  end
end
