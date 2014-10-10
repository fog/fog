module Fog
  module Compute
    class Azure
      class Real

        def reboot_server(vm_name, cloud_service_name)
          @vm_svc.restart_virtual_machine(vm_name, cloud_service_name)
        end

      end

      class Mock

        def reboot_server(vm_name, cloud_service_name)
          nil
        end

      end
    end
  end
end
