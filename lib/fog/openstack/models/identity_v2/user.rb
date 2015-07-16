require 'fog/openstack/models/model'

module Fog
  module Identity
    class OpenStack
      class V2
        class User < Fog::OpenStack::Model
          identity :id

          attribute :email
          attribute :enabled
          attribute :name
          attribute :tenant_id, :aliases => 'tenantId'
          attribute :password

          attr_accessor :email, :name, :tenant_id, :enabled, :password

          def ec2_credentials
            requires :id
            service.ec2_credentials(:user => self)
          end

          def save
            raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
            requires :name, :tenant_id, :password
            enabled = true if enabled.nil?
            data = service.create_user(name, password, email, tenant_id, enabled)
            merge_attributes(data.body['user'])
            true
          end

          def update(options = {})
            requires :id
            options.merge('id' => id)
            response = service.update_user(id, options)
            true
          end

          def update_password(password)
            update({'password' => password, 'url' => "/users/#{id}/OS-KSADM/password"})
          end

          def update_tenant(tenant)
            tenant = tenant.id if tenant.class != String
            update({:tenantId => tenant, 'url' => "/users/#{id}/OS-KSADM/tenant"})
          end

          def update_enabled(enabled)
            update({:enabled => enabled, 'url' => "/users/#{id}/OS-KSADM/enabled"})
          end

          def destroy
            requires :id
            service.delete_user(id)
            true
          end

          def roles(tenant_id = self.tenant_id)
            service.list_roles_for_user_on_tenant(tenant_id, self.id).body['roles']
          end
        end # class User
      end # class V2
    end # class OpenStack
  end # module Identity
end # module Fog
