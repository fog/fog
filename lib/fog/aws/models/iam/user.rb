require 'fog/core/model'

module Fog
  module AWS
    class IAM

      class User < Fog::Model

        identity  :id, :aliases => 'UserName'
        attribute :path, :aliases => 'Path'
        attribute :arn, :aliases => 'Arn'
        attribute :user_id, :aliases => 'UserId'
        
        def save
          requires :id
          data = connection.create_user(id, path || '/').body['User']
          merge_attributes(data)
          true
        end
        
        def destroy
          requires :id
          connection.delete_user(id)
          true
        end
        
        def policies
          requires :id
          connection.policies(:username => id)
        end
        
        def access_keys
          requires :id
          connection.access_keys(:username => id)
        end
        
      end
    end
  end
end