module Fog
  module Compute
    class Vsphere
      class Real

        def vm_snapshot_create(options = {})
          options = { 'force' => false }.merge(options)
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          raise ArgumentError, "name is a required parameter" unless options.has_key? 'name'

          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first

          task = vm_mob_ref.CreateSnapshot_Task(:name=>options['name'],:memory=>false,:quiesce=>true)
          task.wait_for_completion
        end

      end

      class Mock

        def vm_snapshot_create(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          { 'task_state'     => "running", 'reboot_type' => options['force'] ? 'reset_power' : 'reboot_guest' }
        end

      end
    end
  end
end
