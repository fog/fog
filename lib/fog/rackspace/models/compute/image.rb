require 'fog/core/model'

module Fog
  module Compute
    class Rackspace
      class Image < Fog::Model
        identity :id

        attribute :name
        attribute :created_at,  :aliases => 'created'
        attribute :updated_at,  :aliases => 'updated'
        attribute :progress
        attribute :status
        attribute :server_id,   :aliases => 'serverId'

        def server=(new_server)
          requires :id

          self.server_id = new_server.id
        end

        def destroy
          requires :id

          service.delete_image(id)
          true
        end

        def ready?
          status == 'ACTIVE'
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :server_id

          data = service.create_image(server_id, 'name' => name)
          merge_attributes(data.body['image'])
          true
        end
      end
    end
  end
end
