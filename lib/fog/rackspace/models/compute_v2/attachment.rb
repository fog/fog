require 'fog/core/model'

module Fog
  module Compute
    class RackspaceV2
      class Attachment < Fog::Model
        attribute :server_id, :aliases => 'serverId'
        attribute :volume_id, :aliases => 'volumeId'
        attribute :device

        def initialize(new_attributes = {})
          super(new_attributes)
          server_id = server.id if server #server id should come from collection
          self
        end
        
        def save
          requires :server_id, :volume_id, :device
          data = service.attach_volume(server_id, volume_id, device)
          merge_attributes(data.body['volumeAttachment'])
          true
        end

        def destroy
          requires :server_id, :volume_id
          service.delete_attachment(server_id, volume_id)
          true
        end
        alias :detach :destroy
        
      private
        def server
          collection.server
        end
      end
    end
  end
end
