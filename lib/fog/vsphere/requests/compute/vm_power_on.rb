module Fog
  module Compute
    class Vsphere
      class Real

        def vm_power_on(params = {})
          raise ArgumentError ":instance_uuid is a required parameter" unless params.has_key? :instance_uuid
          unless vm = find_all_by_instance_uuid(params[:instance_uuid]).shift
            raise Fog::Vsphere::Errors::NotFound, "Could not find a VM with instance UUID: #{params[:instance_uuid]}"
          end
          task = vm.PowerOnVM_Task
          task.wait_for_completion
          # 'success', 'running', 'queued', 'error'
          task.info.state
        end

      end

      class Mock

        def vm_power_on(params = {})
          # Mock the task.info.state object
          "success"
        end

      end
    end
  end
end
