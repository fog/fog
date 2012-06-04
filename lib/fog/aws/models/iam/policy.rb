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

          data = connection.put_user_policy(username, id, document).body
          merge_attributes(data)
          true
        end
        
        def destroy
          requires :id
          requires :username

          connection.delete_user_policy(username, id)
          true
        end
        
        def user
          requires :username
          connection.users.get(username)
        end
        
        # Converts attributes to a parameter hash suitable for requests
#        def attributes_to_params
#          options = {
#            'PolicyName'      => id,
#            'UserName'        => username,
#            'PolicyDocument'  => document
#          }
#
#          options.delete_if {|key, value| value.nil?}
#        end
        
      end
    end
  end
end