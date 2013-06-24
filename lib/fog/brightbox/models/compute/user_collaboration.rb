require 'fog/core/model'

module Fog
  module Compute
    class Brightbox
      class UserCollaboration < Fog::Model
        identity  :id
        attribute :status
        attribute :email
        attribute :role
        attribute :role_label
        attribute :account
        attribute :user
        attribute :inviter

        def account_id
          account['id'] || account[:id]
        end

        def destroy
          requires :identity
          connection.destroy_user_collaboration(identity)
          true
        end

      end
    end
  end
end
