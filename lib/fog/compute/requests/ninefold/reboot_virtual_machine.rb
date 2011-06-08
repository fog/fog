module Fog
  module Ninefold
    class Compute
      class Real

        def reboot_virtual_machine(options = {})
          request('rebootVirtualMachine', options, :expects => [200],
                  :response_prefix => 'rebootvirtualmachineresponse', :response_type => Hash)
        end

      end
    end
  end
end
