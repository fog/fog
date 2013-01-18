require 'fog/core/model'

module Fog
  module Rackspace
    class Identity
      class User < Fog::Model
        identity :id

        attribute :username
        attribute :password, :alias => 'OS-KSADM:password'
        attribute :email
        attribute :enabled
        attribute :created
        attribute :updated

        def save
          requires :username, :email, :enabled
          unless persisted?
            data = service.create_user(username, email, enabled, :password => password)
          else
            data = service.update_user(identity, username, email, enabled, :password => password)
          end
          merge_attributes(data.body['user'])
          true
        end

        def destroy
          requires :identity
          service.delete_user(identity)
          true
        end

        def roles
          @roles ||= begin
            Fog::Rackspace::Identity::Roles.new({
              :service => service,
              :user => self
            })
          end
        end

        def credentials
          @credentials ||= begin
            Fog::Rackspace::Identity::Credentials.new({
              :service => service,
              :user => self
            })
          end
        end
      end
    end
  end
end
