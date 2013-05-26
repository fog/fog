require 'fog/core/model'

module Fog
  module Volume
    class OpenStack
      class Snapshot < Fog::Model
        identity :id

        attribute :display_name,        :aliases => 'displayName'
        attribute :display_description, :aliases => 'displayDescription'
        attribute :status
        attribute :size        
        attribute :volume_id,           :aliases => 'snapshotId'
        attribute :created_at,          :aliases => 'createdAt'
        attribute :metadata        
        attribute :progress,            :aliases => 'os-extended-snapshot-attributes:progress'
        attribute :project_id,          :aliases => 'os-extended-snapshot-attributes:project_id'

        def initialize(attributes)
          prepare_service_value(attributes)
          super
        end

        def save(force = false)
          requires :volume_id, :display_name, :display_description
          identity ? update : create(force)
        end

        def create(force = false)
          requires :volume_id, :display_name, :display_description
          merge_attributes(service.create_snapshot(self.volume_id,
                                                    self.display_name,
                                                    self.display_description,                                                          
                                                    force,
                                                    self.attributes).body['snapshot'])
          self
        end

        def update
          requires :id, :volume_id, :display_name, :display_description
          merge_attributes(service.update_snapshot(self.id,
                                                   self.attributes).body['snapshot'])
          self
        end

        def destroy
          requires :id
          service.delete_snapshot(self.id)
          true
        end

      end
    end
  end
end