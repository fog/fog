require 'fog/core/model'

module Fog
  module Volume
    class OpenStack

      class Volume < Fog::Model

        identity :id

        attribute :display_name,        :aliases => 'displayName'
        attribute :display_description, :aliases => 'displayDescription'
        attribute :status
        attribute :size
        attribute :volume_type,         :aliases => ['volumeType', 'type']
        attribute :snapshot_id,         :aliases => 'snapshotId'
        attribute :imageRef,            :aliases => 'image_id'
        attribute :availability_zone,   :aliases => 'availabilityZone'
        attribute :created_at,          :aliases => 'createdAt'
        attribute :attachments
        attribute :source_volid


        def initialize(attributes)
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)
          super
        end

        def save
          requires :display_name, :size
          data = service.create_volume(display_name, display_description, size, attributes)
          merge_attributes(data.body['volume'])
          true
        end

        def destroy
          requires :id
          service.delete_volume(id)
          true
        end

      end

    end
  end

end

