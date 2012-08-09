require 'fog/core/model'

module Fog
  module BlockStorage
    class HP

      class Snapshot < Fog::Model

        identity  :id

        attribute :name,                 :aliases => 'displayName'
        attribute :description,          :aliases => 'displayDescription'
        attribute :size
        attribute :status
        attribute :created_at,           :aliases => 'createdAt'
        attribute :volume_id,            :aliases => 'volumeId'
        #attribute :metadata

        def initialize(attributes = {})
          # assign these attributes first to prevent race condition with new_record?
          self.force = attributes.delete(:force)   # force snapshotting of attached volumes
          super
        end

        def destroy
          requires :id
          connection.delete_snapshot(id)
          true
        end

        def force=(new_force)
          @force = new_force
        end

        def ready?
          self.status == 'available'
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :name, :volume_id
          options = {
            #'metadata'        => metadata,      # TODO: Add metadata when snapshots support it
            'force'           => @force
          }
          options = options.reject {|key, value| value.nil?}
          data = connection.create_snapshot(name, description, volume_id, options)
          merge_attributes(data.body['snapshot'])
          true
        end

      end

    end
  end
end
