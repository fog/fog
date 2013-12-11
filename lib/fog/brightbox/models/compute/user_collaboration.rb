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

        def accept
          requires :identity
          data = service.accept_user_collaboration(identity)
          merge_attributes(data)
          true
        end

        def reject
          requires :identity
          data = service.reject_user_collaboration(identity)
          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          data = service.destroy_user_collaboration(identity)
          merge_attributes(data)
          true
        end

      end
    end
  end
end
