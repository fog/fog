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
          if identity.nil?
            data = connection.create_user(username, email, enabled, :password => password)
          else
            data = connection.update_user(identity, username, email, enabled, :password => password)
          end
          merge_attributes(data.body['user'])
          true
        end

        def destroy
          requires :identity
          connection.delete_user(identity)
          true
        end

        def roles
          @roles ||= begin
            Fog::Rackspace::Identity::Roles.new({
              :connection => connection,
              :user => self
            })
          end
        end

        def credentials
          @credentials ||= begin
            Fog::Rackspace::Identity::Credentials.new({
              :connection => connection,
              :user => self
            })
          end
        end
      end
    end
  end
end
