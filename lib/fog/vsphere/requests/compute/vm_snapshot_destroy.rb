module Fog
  module Compute
    class Vsphere
      class Real

        def vm_snapshot_destroy(options = {})
          options = { 'force' => false }.merge(options)
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          raise ArgumentError, "snapshot_id is a required parameter" unless options.has_key? 'snapshot_id'

          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first
          raise "Instance #{options['instance_uuid']} has no snapshots" unless vm_mob_ref.snapshot
          
          snapshots = []
          vm_mob_ref.snapshot.rootSnapshotList.each{|tree|
            get_snapshots(snapshots,tree)
          }
          snapshot_id = options["snapshot_id"].to_i
          snapshot_ref = snapshots.find{|sp|sp['id'] == snapshot_id}['snapshot']
          raise "Instance #{options['instance_uuid']} has no snapshots snapshot_id #{snapshot_id}" unless snapshot_ref
          task = snapshot_ref.RemoveSnapshot_Task(:removeChildren=>true)
          task.wait_for_completion
        end

      end

      class Mock

        def vm_snapshot_destroy(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          { 'task_state'     => "running", 'reboot_type' => options['force'] ? 'reset_power' : 'reboot_guest' }
        end

      end
    end
  end
end
