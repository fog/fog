module Fog
  module Compute
    class Vsphere
      class Real

        def vm_destroy(params = {})
          raise ArgumentError ":instance_uuid is a required parameter" unless params.has_key? :instance_uuid
          vm = find_all_by_instance_uuid(params[:instance_uuid]).first
          unless vm.kind_of? RbVmomi::VIM::VirtualMachine
            raise Fog::Vsphere::Errors::NotFound, "Could not find VirtualMachine with instance uuid #{params[:instance_uuid]}"
          end
          task = vm.Destroy_Task
          task.wait_for_completion
          task.info.state
        end

      end

      class Mock

        def vm_destroy(params = {})
          "success"
        end

      end
    end
  end
end
