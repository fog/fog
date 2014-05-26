module Fog
  module Compute
    class Vsphere
      class Real
        def vm_power_off(options = {})
          options = { 'force' => false }.merge(options)
          raise ArgumentError, "instance_uuid is a required parameter" unless options.key? 'instance_uuid'

          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first

          if options['force'] then
            task = vm_mob_ref.PowerOffVM_Task
            task.wait_for_completion
            { 'task_state' => task.info.result, 'power_off_type' => 'cut_power' }
          else
            vm_mob_ref.ShutdownGuest
            {
              'task_state'     => "running",
              'power_off_type' => 'shutdown_guest',
            }
          end
        end
      end

      class Mock
        def vm_power_off(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.key? 'instance_uuid'
          vm = get_virtual_machine(options['instance_uuid'])
          vm["power_state"] = "poweredOff"
          {
            'task_state'     => "running",
            'power_off_type' => options['force'] ? 'cut_power' : 'shutdown_guest',
          }
        end
      end
    end
  end
end
