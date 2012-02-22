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
      end # class Tenant
    end # class OpenStack
  end # module Identity
end # module Fog
