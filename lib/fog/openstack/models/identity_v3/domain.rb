require 'fog/core/model'

module Fog
  module Identity
    class OpenStack
      class V3
        class Domain < Fog::Model
          identity :id

          attribute :description
          attribute :enabled
          attribute :name
          attribute :links

          def to_s
            self.name
          end

          def destroy
            requires :id
            service.delete_domain(self.id)
            true
          end

          def update(attr = nil)
            requires :id
            merge_attributes(
                service.update_domain(self.id, attr || attributes).body['domain'])
            self
          end

          def save
            requires :name
            identity ? update : create
          end

          def create
            merge_attributes(
                service.create_domain(attributes).body['domain'])
            self
          end

        end
      end
    end
  end
end