module Fog
  module Compute
    class Vsphere
      class Real
        def list_child_snapshots(snapshot, opts = {})
          normalized_snapshot = Hash === snapshot ?
            Snapshot.new(snapshot.update(service: self)) : snapshot

          child_snapshots = normalized_snapshot.tree_node.childSnapshotList.map do |snap|
            item = child_snapshot_info(snap, normalized_snapshot)
            [
              item,
              opts[:recursive] ? list_child_snapshots(item, opts) : nil
            ]
          end

          child_snapshots.flatten.compact
        end

        protected

          def child_snapshot_info(snap_tree, parent_snap)
            {
              name: snap_tree.name,
              quiesced: snap_tree.quiesced,
              description: snap_tree.description,
              create_time: snap_tree.createTime,
              power_state: snap_tree.state,
              ref: snap_tree.snapshot._ref,
              mo_ref: snap_tree.snapshot,
              tree_node: snap_tree,
              snapshot_name_chain:
                "#{parent_snap.snapshot_name_chain}/#{snap_tree.name}",
              ref_chain:
                "#{parent_snap.ref_chain}/#{snap_tree.snapshot._ref}"
            }
          end
      end
      class Mock
        def list_child_snapshots(snapshot, opts = {})
          [
            {
              name: 'clean',
              quiesced: false,
              description: '',
              create_time: Time.now.utc,
              power_state: 'poweredOn',
              ref: 'snapshot-0101',
              mo_ref: nil,
              tree_node: nil,
              snapshot_name_chain: '123/clean',
              ref_chain: '123/snap-0101'
            },
            {
              name: 'dirty',
              quiesced: false,
              description: '',
              create_time: Time.now.utc,
              power_state: 'poweredOn',
              ref: 'snapshot-0102',
              mo_ref: nil,
              tree_node: nil,
              snapshot_name_chain: '123/dirty',
              ref_chain: '123/snap-0102'
            }
          ]
        end
      end
    end
  end
end
