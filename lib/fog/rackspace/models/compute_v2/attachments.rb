require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/attachment'

module Fog
  module Compute
    class RackspaceV2
      class Attachments < Fog::Collection

        model Fog::Compute::RackspaceV2::Attachment

        attr_accessor :server

        def all
          data = connection.list_attachments(server.id).body['volumeAttachments']
          load(data)
        end

        def get(volume_id)
          data = connection.get_attachment(server.id, volume_id).body['volumeAttachment']
          data && new(data)
        end
      end
    end
  end
end
