require 'fog/core/model'

module Fog
  module Identity
    class OpenStack
      class V3
        class Token < Fog::Model

          attribute :value
          attribute :catalog
          attribute :expires_at
          attribute :issued_at
          attribute :methods
          attribute :project
          attribute :roles
          attribute :user

          def to_s
            self.value
          end

        end
      end
    end
  end
end