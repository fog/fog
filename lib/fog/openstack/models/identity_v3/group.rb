require 'fog/core/model'

module Fog
  module Identity
    class OpenStack
      class V3
        class Group < Fog::Model
          identity :id

          attribute :description
          attribute :domain_id
          attribute :name
          attribute :links

          def to_s
            self.name
          end

          def destroy
            requires :id
            service.delete_group(self.id)
            true
          end

          def update(attr = nil)
            requires :id
            merge_attributes(
                service.update_group(self.id, attr || attributes).body['group'])
            self
          end

          def save
            requires :name
            identity ? update : create
          end

          def create
            merge_attributes(
                service.create_group(attributes).body['group'])
            self
          end

          def add_user user_id
            requires :id
            service.add_user_to_group(self.id, user_id)
          end

          def remove_user user_id
            requires :id
            service.remove_user_from_group(self.id, user_id)
          end

          def contains_user? user_id
            requires :id
            begin
              service.group_user_check(self.id, user_id)
            rescue Fog::Identity::OpenStack::NotFound
              return false
            end
            return true
          end

          def roles
            requires :id, :domain_id
            service.list_domain_group_roles(self.domain_id, self.id).body['roles']
          end

          def grant_role(role_id)
            requires :id, :domain_id
            service.grant_domain_group_role(self.domain_id, self.id, role_id)
          end

          def check_role(role_id)
            requires :id, :domain_id
            begin
              service.check_domain_group_role(self.domain_id, self.id, role_id)
            rescue Fog::Identity::OpenStack::NotFound
              return false
            end
            return true
          end

          def revoke_role(role_id)
            requires :id, :domain_id
            service.revoke_domain_group_role(self.domain_id, self.id, role_id)
          end

          def users(attr = {})
            requires :id
            service.list_group_users(self.id, attr).body['users']
          end
        end
      end
    end
  end
end