require 'fog/core/model'

module Fog
  module Compute
    class Brightbox

      class User < Fog::Model

        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :email_address
        attribute :ssh_key

        # Boolean flags
        attribute :email_verified
        attribute :messaging_pref

        # Links - to be replaced
        attribute :account_id, :aliases => "default_account", :squash => "id"
        attribute :accounts

        def save
          requires :identity

          options = {
            :email_address => email_address,
            :ssh_key => ssh_key,
            :name => name
          }

          data = service.update_user(identity, options)
          merge_attributes(data)
          true
        end

      end

    end
  end
end
