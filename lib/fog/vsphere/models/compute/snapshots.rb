require 'fog/core/collection'
require 'fog/vsphere/models/compute/snapshot'

module Fog
  module Compute
    class Vsphere
      class Snapshots < Fog::Collection
        attribute :server_id, alias: :instance_uuid
        attribute :parent_snapshot
        model Fog::Compute::Vsphere::Snapshot

        def all(filters = {})
          if parent_snapshot
            load service.list_child_snapshots(parent_snapshot, filters)
          else
            requires :server_id
            load service.list_vm_snapshots(server_id, filters)
          end
        end

        def get(snapshot_ref)
          all.find { |snapshot| snapshot.get_child(snapshot_ref) }
        end
      end
    end
  end
end
