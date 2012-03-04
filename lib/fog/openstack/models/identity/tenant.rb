require 'fog/core/model'

module Fog
  module Identity
    class OpenStack
      class Tenant < Fog::Model
        identity :id

        attribute :description
        attribute :enabled
        attribute :name

        def to_s
          self.name
        end

        def roles_for(user)
          connection.roles(
            :tenant => self,
            :user   => user)
        end

        def destroy
          requires :id
          connection.delete_tenant(self.id)
          true
        end

        def update(attr = nil)
          requires :id
          merge_attributes(
            connection.update_tenant(self.id, attr || attributes).body['tenant'])
          self
        end

        def save
          requires :name
          identity ? update : create
        end

        def create
          merge_attributes(
            connection.create_tenant(attributes).body['tenant'])
          self
        end

        def add_user(user_id, role_id)
          connection.add_user_to_tenant(self.id, user_id, role_id)
        end  
      end # class Tenant
    end # class OpenStack
  end # module Identity
end # module Fog
