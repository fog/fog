require 'fog/core/model'

module Fog
  module Compute
    class RackspaceV2
      class Attachment < Fog::Model
        identity :id

        attribute :server_id, :aliases => 'serverId'
        attribute :volume_id, :aliases => 'volumeId'
        attribute :device

        def save
          requires :server, :identity, :device
          data = connection.attach_volume(server.identity, identity, device)
          merge_attributes(data.body['volumeAttachment'])
          true
        end

        def destroy
          requires :server, :identity
          connection.delete_attachment(server.identity, identity)
          true
        end

        private

        def server
          collection.server
        end
      end
    end
  end
end
