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

          data = connection.create_user(id).body['User']
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
          connection.policies(:user => self)
        end
        
        def access_keys
          requires :id
          connection.access_keys(:user => self)
        end
#        # Converts attributes to a parameter hash suitable for requests
#        def attributes_to_params
#          options = {
#            'UserName' => id,
#            'Path'     => path,
#            'Arn'      => arn,
#            'UserId'   => user_id
#          }
#
#          options.delete_if {|key, value| value.nil?}
#        end
        
      end
    end
  end
end