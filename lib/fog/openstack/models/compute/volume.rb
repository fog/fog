require 'fog/core/model'
require 'fog/openstack/models/compute/metadata'

module Fog
  module Compute
    class OpenStack

      class Volume < Fog::Model

        identity :id

        attribute :name,                :aliases => 'displayName'
        attribute :description,         :aliases => 'displayDescription'
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
          requires :name, :description, :size
          data = connection.create_volume(name, description, size, attributes)
          merge_attributes(data.body['volume'])
          true
        end

        def destroy
          requires :id
          connection.delete_volume(id)
          true
        end

        def attach(server_id, name)
          requires :id
          data = connection.attach_volume(id, server_id, name)
          merge_attributes(:attachments => attachments << data.body['volumeAttachment'])
          true
        end

        def detach(server_id, attachment_id)
          requires :id
          connection.detach_volume(server_id, attachment_id)
          true
        end
      end

    end
  end

end
