module Fog
  module Compute
    class Vsphere
      class Real
        def list_vm_snapshots(vm_id, opts = {})
          root_snapshots = get_vm_ref(vm_id).snapshot.rootSnapshotList.map do |snap|
            item = snapshot_info(snap, vm_id)
            [
              item,
              opts[:recursive] ? list_child_snapshots(item, opts) : nil
            ]
          end

          root_snapshots.flatten.compact
        end

        protected

          def snapshot_info(snap_tree, vm_id)
            {
              name: snap_tree.name,
              quiesced: snap_tree.quiesced,
              description: snap_tree.description,
              create_time: snap_tree.createTime,
              power_state: snap_tree.state,
              ref: snap_tree.snapshot._ref,
              mo_ref: snap_tree.snapshot,
              tree_node: snap_tree,
              ref_chain: "#{vm_id}/#{snap_tree.snapshot._ref}",
              snapshot_name_chain: "#{vm_id}/#{snap_tree.name}"
            }
          end
      end
      class Mock
        def list_vm_snapshots(vm_id, opts = {})
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
              ref_chain: "#{vm_id}/snapshot-0101"
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
              ref_chain: "#{vm_id}/snapshot-0102"
            }
          ]
        end
      end
    end
  end
end
