require 'fog/openstack/models/collection'
require 'fog/openstack/models/identity_v3/domain'

module Fog
  module Identity
    class OpenStack
      class V3
        class Users < Fog::OpenStack::Collection
          model Fog::Identity::OpenStack::V3::User

          def all(options = {})
            load_response(service.list_users(options), 'users')
          end

          def find_by_id(id)
            cached_user = self.find { |user| user.id == id }
            return cached_user if cached_user
            user_hash = service.get_user(id).body['user']
            Fog::Identity::OpenStack::V3::User.new(
                user_hash.merge(:service => service))
          end

          def find_by_name(name)
            load(service.list_users(:name => name).body['users'])
          end

          def destroy(id)
            user = self.find_by_id(id)
            user.destroy
          end
        end
      end
    end
  end
end
