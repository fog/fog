module Fog
  module Compute
    class Vsphere
      class Real

        def vm_reboot(options = {})
          options = { 'force' => false }.merge(options)
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'

          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first

          if options['force'] then
            task = vm_mob_ref.ResetVM_Task
            task.wait_for_completion
            { 'task_state' => task.info.result, 'reboot_type' => 'reset_power' }
          else
            vm_mob_ref.ShutdownGuest
            { 'task_state' => "running", 'reboot_type' => 'reboot_guest' }
          end
        end

      end

      class Mock

        def vm_reboot(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          { 'task_state'     => "running", 'reboot_type' => options['force'] ? 'reset_power' : 'reboot_guest' }
        end

      end
    end
  end
end
