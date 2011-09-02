module Fog
  module Compute
    class Vsphere
      class Real

        def vm_power_off(params = {})
          params = { :force => false }.merge(params)
          raise ArgumentError ":instance_uuid is a required parameter" unless params.has_key? :instance_uuid
          unless vm = find_all_by_instance_uuid(params[:instance_uuid]).shift
            raise Fog::Vsphere::Errors::NotFound, "Could not find a VM with instance UUID: #{params[:instance_uuid]}"
          end
          if params[:force] then
            task = vm.PowerOffVM_Task
            task.wait_for_completion
            task.info.result
          else
            vm.ShutdownGuest
            "running"
          end
        end

      end

      class Mock

        def vm_power_off(params = {})
          "running"
        end

      end
    end
  end
end
