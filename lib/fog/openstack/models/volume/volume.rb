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
        attribute :type,                :aliases => 'volumeType'
        attribute :snapshot_id,         :aliases => 'snapshotId'
        attribute :availability_zone,   :aliases => 'availabilityZone'
        attribute :created_at,          :aliases => 'createdAt'
        attribute :attachments


        def initialize(attributes)
          @connection = attributes[:connection]
          super
        end

        def save
          requires :display_name, :size
          data = connection.create_volume(display_name, display_description, size, attributes)
          merge_attributes(data.body['volume'])
          true
        end

        def destroy
          requires :id
          connection.delete_volume(id)
          true
        end

      end

    end
  end

end

