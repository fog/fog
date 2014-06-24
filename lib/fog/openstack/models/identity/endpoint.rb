require 'fog/core/model'

module Fog
  module Identity
    class OpenStack
      class Endpoint < Fog::Model
        identity :id
        attribute :region
        attribute :publicurl
        attribute :internalurl
        attribute :adminurl
        attribute :service_id

        def save
          requires :region, :publicurl, :internalurl, :adminurl, :service_id
          identity ? update : create
        end

        def create
          data = service.create_endpoint(region, publicurl, internalurl, adminurl, service_id)
          merge_attributes(data.body['endpoint'])
          self
        end

        def update(attr = nil)
          requires :id
          merge_attributes(
            service.update_endpoint(self.id, attr || attributes).body['endpoint'])
          self
        end

        def destroy
          requires :id
          service.delete_endpoint(id)
          true
        end
      end # class Endpoint
    end # class OpenStack
  end # module Identity
end # module Fog
