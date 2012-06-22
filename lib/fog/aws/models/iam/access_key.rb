require 'fog/core/model'

module Fog
  module AWS
    class IAM

      class AccessKey < Fog::Model

        identity  :id, :aliases => 'AccessKeyId'
        attribute :username, :aliases => 'UserName'
        attribute :secret_access_key, :aliases => 'SecretAccessKey'
        attribute :status, :aliases => 'Status'
        
        def save
          requires :username

          data = connection.create_access_key('UserName'=> username).body["AccessKey"]
          merge_attributes(data)
          true
        end
        
        def destroy
          requires :id
          requires :username

          connection.delete_access_key(id,'UserName'=> username)
          true
        end
        
        def user
          requires :username
          connection.users.get(username)
        end
        
      end
    end
  end
end