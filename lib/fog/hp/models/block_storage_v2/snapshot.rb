require 'fog/core/model'

module Fog
  module HP
    class BlockStorageV2
      class Snapshot < Fog::Model
        identity  :id

        attribute :name,                 :aliases => 'display_name'
        attribute :description,          :aliases => 'display_description'
        attribute :size
        attribute :status
        attribute :created_at
        attribute :volume_id
        attribute :metadata

        def initialize(attributes = {})
          # assign these attributes first to prevent race condition with persisted?
          self.force = attributes.delete(:force)   # force snapshotting of attached volumes
          super
        end

        def destroy
          requires :id
          service.delete_snapshot(id)
          true
        end

        def force=(new_force)
          @force = new_force
        end

        def ready?
          self.status == 'available'
        end

        def save
          identity ? update : create
        end

        private

        def create
          requires :volume_id
          options = {
            'display_name'        => name,
            'display_description' => description,
            'force'               => @force,
            'metadata'            => metadata
          }
          options = options.reject {|_, value| value.nil?}
          data = service.create_snapshot(volume_id, options)
          merge_attributes(data.body['snapshot'])
          true
        end

        def update
          requires :id
          options = {
            'display_name'        => name,
            'display_description' => description,
            'metadata'            => metadata
          }
          options = options.reject {|_, value| value.nil?}
          data = service.update_snapshot(id, options)
          merge_attributes(data.body['snapshot'])
          true
        end
      end
    end
  end
end
