require 'fog/core/collection'
require 'fog/openstack/models/identity_v2/user'

module Fog
  module Identity
    class OpenStack
      class V2
        class Users < Fog::Collection
          model Fog::Identity::OpenStack::V2::User

          attribute :tenant_id

          def all(options = {})
            options[:tenant_id] = tenant_id

            load(service.list_users(options).body['users'])
          end

          alias_method :summary, :all

          def find_by_id(id)
            self.find { |user| user.id == id } ||
                Fog::Identity::OpenStack::V2::User.new(
                    service.get_user_by_id(id).body['user'].merge(
                        'service' => service
                    )
                )
          end

          def find_by_name(name)
            self.find { |user| user.name == name } ||
                Fog::Identity::OpenStack::V2::User.new(
                    service.get_user_by_name(name).body['user'].merge(
                        'service' => service
                    )
                )
          end

          def destroy(id)
            user = self.find_by_id(id)
            user.destroy
          end
        end # class Users
      end # class V2
    end # class OpenStack
  end # module Identity
end # module Fog
