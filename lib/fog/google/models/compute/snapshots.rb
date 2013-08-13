require 'fog/core/collection'
require 'fog/google/models/compute/snapshot'

module Fog
  module Compute
    class Google

      class Snapshots < Fog::Collection

        model Fog::Compute::Google::Snapshot

        def all
          data = service.list_snapshots(self.service.project)
          snapshots = data.body['items'] || []
          load(snapshots)
        end

        def get(snap_id)
          response = service.get_snapshot(snap_id, self.service.project)
          return nil if response.nil?
          new(response.body)
        end

      end

    end
  end
end
