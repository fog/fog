require 'fog/openstack/models/model'

module Fog
  module Identity
    class OpenStack
      class V3
        class Project < Fog::OpenStack::Model
          identity :id

          attribute :domain_id
          attribute :description
          attribute :enabled
          attribute :name
          attribute :links
          attribute :parent_id
          attribute :subtree
          attribute :parents

          def to_s
            self.name
          end

          def destroy
            @@cache.clear if @@cache
            requires :id
            service.delete_project(self.id)
            true
          end

          def update(attr = nil)
            @@cache.clear if @@cache
            requires :id
            merge_attributes(
                service.update_project(self.id, attr || attributes).body['project'])
            self
          end

          def create
            @@cache.clear if @@cache
            merge_attributes(
                service.create_project(attributes).body['project'])
            self
          end

          def user_roles(user_id)
            requires :id
            service.list_project_user_roles(self.id, user_id).body['roles']
          end

          def grant_role_to_user(role_id, user_id)
            @@cache.clear if @@cache
            requires :id
            service.grant_project_user_role(self.id, user_id, role_id)
          end

          def check_user_role(user_id, role_id)
            requires :id
            begin
              service.check_project_user_role(self.id, user_id, role_id)
            rescue Fog::Identity::OpenStack::NotFound
              return false
            end
            return true
          end

          def revoke_role_from_user(role_id, user_id)
            @@cache.clear if @@cache
            requires :id
            service.revoke_project_user_role(self.id, user_id, role_id)
          end

          def group_roles(group_id)
            requires :id
            service.list_project_group_roles(self.id, group_id).body['roles']
          end

          def grant_role_to_group(role_id, group_id)
            @@cache.clear if @@cache
            requires :id
            service.grant_project_group_role(self.id, group_id, role_id)
          end

          def check_group_role(group_id, role_id)
            requires :id
            begin
              service.check_project_group_role(self.id, group_id, role_id)
            rescue Fog::Identity::OpenStack::NotFound
              return false
            end
            return true
          end

          def revoke_role_from_group(role_id, group_id)
            @@cache.clear if @@cache
            requires :id
            service.revoke_project_group_role(self.id, group_id, role_id)
          end

          def self.use_cache(cache)
            @@cache = cache
          end
        end
      end
    end
  end
end
