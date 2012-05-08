module Fog
  module Compute
    class Vsphere
      class Real

        def vm_power_off(options = {})
          options = { 'force' => false }.merge(options)
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'

          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first

          if options['force'] then
            task = vm_mob_ref.PowerOffVM_Task
            state = task.info.state
            while (state != 'error') and (state != 'success')
              sleep(2)
              state = task.info.state
            end
            #task.wait_for_completion
            { 'task_state' => state, 'power_off_type' => 'cut_power' }
          else
            vm_mob_ref.ShutdownGuest
            if options['wait'] then
              stats = vm_mob_ref.guest.guestState
              while(stats!="notRunning")
                sleep(6)
                stats = vm_mob_ref.guest.guestState
                { 'task_state' => "running", 'power_off_type' => 'shutdown_guest' }
              end
              { 'task_state' => "success", 'power_off_type' => 'shutdown_guest' }
            else
              {
                  'task_state'     => "running",
                  'power_off_type' => 'shutdown_guest',
              }
            end

          end
        end

      end

      class Mock

        def vm_power_off(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          {
              'task_state'     => "running",
              'power_off_type' => options['force'] ? 'cut_power' : 'shutdown_guest',
          }
        end

      end
    end
  end
end
