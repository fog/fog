require 'fog/core/model'

module Fog
  module AWS
    class IAM

      class User < Fog::Model

        identity  :id, :aliases => 'UserName'
        attribute :path, :aliases => 'Path'
        attribute :arn, :aliases => 'Arn'
        attribute :user_id, :aliases => 'UserId'
        attribute :created_at, :aliases => 'CreateDate', :type => :time

        def save
          requires :id
          data = service.create_user(id, path || '/').body['User']
          merge_attributes(data)
          true
        end

        def destroy
          requires :id
          service.delete_user(id)
          true
        end

        def policies
          requires :id
          service.policies(:username => id)
        end

        def access_keys
          requires :id
          service.access_keys(:username => id)
        end

      end
    end
  end
end
