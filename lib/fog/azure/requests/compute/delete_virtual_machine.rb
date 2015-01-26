module Fog
  module Compute
    class Azure
      class Real
        def delete_virtual_machine(vm_name, cloud_service_name)
          @vm_svc.delete_virtual_machine(vm_name, cloud_service_name)
        end
      end

      class Mock
        def delete_virtual_machine
          nil
        end
      end
    end
  end
end
