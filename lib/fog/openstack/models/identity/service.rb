require 'fog/core/model'

module Fog
  module Identity
    class OpenStack
      class Service < Fog::Model
        identity :id

        attribute :name
        attribute :type
        attribute :description

        attr_accessor :name, :type, :description

        def save
          requires :name, :type
          identity ? update : create
        end

        def create
          merge_attributes(
            service.create_service(attributes).body['service'])
          self
        end

        def update(attr = nil)
          requires :id
          merge_attributes(
            service.update_service(self.id, attr || attributes).body['service'])
          self
        end

        def destroy
          requires :id
          service.delete_service(id)
          true
        end
      end # class Service
    end # class OpenStack
  end # module Identity
end # module Fog
