require 'fog/core/collection'
require 'fog/openstack/models/compute/snapshot'

module Fog
  module Compute
    class OpenStack

      class Snapshots < Fog::Collection
        model Fog::Compute::OpenStack::Snapshot

        def all(detailed=true)
          load(connection.list_snapshots(detailed).body['snapshots'])
        end

        def get(snapshot_id)
          if snapshot = connection.get_snapshot_details(snapshot_id).body['snapshot']
            new(snapshot)
          end
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end
      end

    end
  end
end
