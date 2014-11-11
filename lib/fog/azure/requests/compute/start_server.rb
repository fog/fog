module Fog
  module Compute
    class Azure
      class Real
        def start_server(vm_name, cloud_service_name)
          @vm_svc.start_virtual_machine(vm_name, cloud_service_name)
        end
      end

      class Mock
        def start_server(vm_name, cloud_service_name)
          nil
        end
      end
    end
  end
end
