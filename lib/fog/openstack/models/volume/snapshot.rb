require 'fog/openstack/models/model'

module Fog
  module Volume
    class OpenStack
      class Snapshot < Fog::OpenStack::Model
        identity :id

        attribute :display_name
        attribute :display_description
        attribute :volume_id
        attribute :status
        attribute :size
        attribute :created_at
        attribute :metadata

        def save(force=false)
          requires :volume_id, :name, :description
          data = service.create_volume_snapshot(volume_id, name, description, force)
          merge_attributes(data.body['snapshot'])
          true
        end

        def destroy
          requires :id
          service.delete_snapshot(id)
          true
        end
      end
    end
  end
end
