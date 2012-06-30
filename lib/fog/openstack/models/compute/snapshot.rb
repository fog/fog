require 'fog/core/model'
require 'fog/openstack/models/compute/metadata'

module Fog
  module Compute
    class OpenStack

      class Snapshot < Fog::Model

        identity :id

        attribute :name,                :aliases => 'displayName'
        attribute :description,         :aliases => 'displayDescription'
        attribute :volume_id,           :aliases => 'volumeId'
        attribute :status
        attribute :size
        attribute :created_at,          :aliases => 'createdAt'


        def initialize(attributes)
          @connection = attributes[:connection]
          super
        end

        def save(force=false)
          requires :volume_id, :name, :description
          data = connection.create_volume_snapshot(volume_id, name, description, force)
          merge_attributes(data.body['snapshot'])
          true
        end

        def destroy
          requires :id
          connection.delete_snapshot(id)
          true
        end

      end

    end
  end

end
