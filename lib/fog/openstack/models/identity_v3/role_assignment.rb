require 'fog/core/model'

module Fog
  module Identity
    class OpenStack
      class V3
        class RoleAssignment < Fog::Model
          attribute :scope
          attribute :role
          attribute :user
          attribute :group
          attribute :links

          def to_s
            self.links['assignment']
          end

        end
      end
    end
  end
end