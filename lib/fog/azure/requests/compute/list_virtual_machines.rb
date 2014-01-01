module Fog
  module Compute
    class Azure

      class Real

        def list_virtual_machines
          @vm_svc.list_virtual_machines
        end

      end

      class Mock

        def list_virtual_machines
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
