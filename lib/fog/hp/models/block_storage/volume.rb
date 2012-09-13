require 'fog/core/model'

module Fog
  module BlockStorage
    class HP

      class Volume < Fog::Model

        identity  :id

        attribute :name,                 :aliases => 'displayName'
        attribute :description,          :aliases => 'displayDescription'
        attribute :size
        attribute :status
        attribute :type,                 :aliases => 'volumeType'
        attribute :created_at,           :aliases => 'createdAt'
        attribute :availability_zone,    :aliases => 'availabilityZone'
        attribute :snapshot_id,          :aliases => 'snapshotId'
        attribute :attachments
        attribute :metadata

        attr_reader :server_id
        attr_reader :device

        def device
          attachments[0]['device'] if has_attachments?
        end

        def server_id
          attachments[0]['serverId'] if has_attachments?
        end

        # a volume can be attached to only one server at a time
        def has_attachments?
          !(attachments.nil? || attachments.empty? || attachments[0].empty?)
        end

        def in_use?
          self.status == 'in-use'
        end

        def ready?
          self.status == 'available'
        end

        # volume can be attached to only one server at a time
        def attach(new_server_id, device)
          requires :id
          unless in_use?
            data = connection.compute.attach_volume(new_server_id, id, device)
            merge_attributes(:attachments => attachments << data.body['volumeAttachment'])
            true
          else
            false
          end
        end

        def detach
          requires :id
          if has_attachments?
            connection.compute.detach_volume(server_id, id)
          end
          true
        end

        def destroy
          requires :id
          connection.delete_volume(id)
          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :name, :size
          options = {
            'metadata'          => metadata,
            'snapshot_id'       => snapshot_id
          }
          options = options.reject {|key, value| value.nil?}
          data = connection.create_volume(name, description, size, options)
          merge_attributes(data.body['volume'])
          true
        end

      end

    end
  end
end
