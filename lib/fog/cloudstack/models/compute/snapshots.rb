require 'fog/core/collection'
require 'fog/cloudstack/models/compute/snapshot'

module Fog
  module Compute
    class Cloudstack

      class Snapshots < Fog::Collection

        model Fog::Compute::Cloudstack::Snapshot

        def all
          data = service.list_snapshots["listsnapshotsresponse"]["snapshot"] || []
          load(data)
        end
        
        def get(snapshot_id)
          snapshots = service.list_snapshots('id' => snapshot_id)["listsnapshotsresponse"]["snapshot"]
          unless snapshots.nil? || snapshots.empty?
              new(snapshots.first)
          end
        rescue Fog::Compute::Cloudstack::BadRequest
          nil
        end
      end

    end
  end
end
