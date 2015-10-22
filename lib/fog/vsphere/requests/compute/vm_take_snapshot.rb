module Fog
  module Compute
    class Vsphere
      class Real
        def vm_take_snapshot(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.key? 'instance_uuid'
          raise ArgumentError, "name is a required parameter" unless options.key? 'name'
          vm = get_vm_ref(options['instance_uuid'])
          task = vm.CreateSnapshot_Task(
            name: options['name'],
            description: options['description'] || '',
            memory: options['memory'] || true,
            quiesce: options['quiesce'] || false
          )

          task.wait_for_completion

          {
            'task_state' => task.info.state,
            'was_cancelled' => task.info.cancelled
          }
        end
      end

      class Mock
        def vm_take_snapshot(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.key? 'instance_uuid'
          raise ArgumentError, "name is a required parameter" unless options.key? 'name'
          {
            'task_state' => 'success',
            'was_cancelled' => false
          }
        end
      end
    end
  end
end
