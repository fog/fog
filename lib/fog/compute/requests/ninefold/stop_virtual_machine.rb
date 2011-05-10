module Fog
  module Ninefold
    class Compute
      class Real

        def stop_virtual_machine(options = {})
          request('stopVirtualMachine', options, :expects => [200],
                  :response_prefix => 'stopvirtualmachineresponse', :response_type => Hash)
        end

      end

      class Mock

        def stop_virtual_machine(*args)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
