require 'fog/core/collection'
require 'fog/hp/models/compute_v2/volume_attachment'

module Fog
  module Compute
    class HPV2
      class VolumeAttachments < Fog::Collection
        model Fog::Compute::HPV2::VolumeAttachment

        attr_accessor :server

        def all
          requires :server
          data = service.list_server_volumes(server.id).body['volumeAttachments']
          load(data)
        end

        def get(volume_id)
          requires :server
          if data = service.get_server_volume_details(server.id, volume_id).body['volumeAttachment']
            new(data)
          end
        rescue Fog::Compute::HPV2::NotFound
          nil
        end
      end
    end
  end
end
