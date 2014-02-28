require 'fog/core/model'

module Fog
  module Compute
    class Brightbox
      class Collaboration < Fog::Model
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

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity

          options = {
            :role => role,
            :email => email
          }.delete_if { |k, v| v.nil? || v == "" }

          data = service.create_collaboration(options)
          merge_attributes(data)
          true
        end

        def resend
          requires :identity
          data = service.resend_collaboration(identity)
          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          data = service.destroy_collaboration(identity)
          merge_attributes(data)
          true
        end
      end
    end
  end
end
