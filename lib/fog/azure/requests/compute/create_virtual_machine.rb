module Fog
  module Compute
    class Azure

      class Real

        def create_virtual_machine(params, options)
          @vm_svc.create_virtual_machine(params, options)
        end

      end

      class Mock

        def create_virtual_machine(params, options)
        end

      end

    end
  end
end
