require 'fog/openstack/models/model'

module Fog
  module Volume
    class OpenStack
      class VolumeType < Fog::OpenStack::Model
        identity :id

        attribute :name
        attribute :volume_backend_name
        attribute :extra_specs

        def create
          requires :name

          response = service.create_volume_type(self.attributes)
          merge_attributes(response.body['volume_type'])

          self
        end

        def update
          requires :id

          response = service.update_volume_type(self.id, self.attributes)
          merge_attributes(response.body['volume_type'])

          self
        end

        def destroy
          requires :id
          service.delete_volume_type(self.id)
          true
        end
      end
    end
  end
end
