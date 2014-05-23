require 'fog/core/model'

module Fog
  module Compute
    class HPV2
      class VolumeAttachment < Fog::Model
        identity  :id

        attribute :server_id, :aliases => 'serverId'
        attribute :volume_id, :aliases => 'volumeId'
        attribute :device

        def initialize(new_attributes = {})
          super(new_attributes)
          # server_id needs to be the same as the server from the attachments collection
          server_id = server.id if server
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
          service.detach_volume(server_id, volume_id)
          true
        end
        alias_method :detach, :destroy

        private
        def server
          collection.server
        end
      end
    end
  end
end
