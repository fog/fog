module Fog
  module Compute
    class Vsphere
      class Real

        def vm_reboot(options = {})
          options = { 'force' => false, 'wait' => true }.merge(options)
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'

          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first

          if options['force'] then
            task = vm_mob_ref.ResetVM_Task
            wait_for_task(task)
            { 'task_state' => task.info.result, 'reboot_type' => 'reset_power' }
          else
            vm_mob_ref.RebootGuest
            if options['wait'] then
              stats = nil
              while( stats == nil || stats != "running")
                sleep(6)
                if vm_mob_ref.guest
                  stats = vm_mob_ref.guest.guestState
                end
                { 'task_state' => "running", 'reboot_type' => 'reboot_guest' }
              end
              { 'task_state' => "success", 'reboot_type' => 'reboot_guest' }
            else
              {
                  'task_state' => "running",
                  'reboot_type' => 'reboot_guest',
              }
            end
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
