module Fog
  module Ninefold
    class Compute
      class Real

        def deploy_virtual_machine(options = {})
          request('deployVirtualMachine', options, :expects => [202])
        end

      end
    end
  end
end
