require 'fog/core/model'

module Fog
  module Identity
    class OpenStack
      class User < Fog::Model
        identity :id

        attribute :email
        attribute :enabled
        attribute :name
        attribute :tenantId

        def roles
          return Array.new unless tenantId
          tenant = Fog::Identity::OpenStack::Tenant.
            new(connection.get_tenant(tenantId).body['tenant'])

          connection.roles(
            :tenant => tenant,
            :user   => self)
        end
      end # class Tenant
    end # class OpenStack
  end # module Identity
end # module Fog

