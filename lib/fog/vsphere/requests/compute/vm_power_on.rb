module Fog
  module Compute
    class Vsphere
      class Real

        def vm_power_on(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'

          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first

          task = vm_mob_ref.PowerOnVM_Task
          task.wait_for_completion
          # 'success', 'running', 'queued', 'error'
          { 'task_state' => task.info.state }
        end

      end

      class Mock

        def vm_power_on(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          { 'task_state' => 'success' }
        end

      end
    end
  end
end
