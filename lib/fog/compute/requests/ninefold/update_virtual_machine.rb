module Fog
  module Ninefold
    class Compute
      class Real

        def update_virtual_machine(options = {})
          request('updateVirtualMachine', options, :expects => [200],
                  :response_prefix => 'updatevirtualmachineresponse', :response_type => Hash)
        end

      end
    end
  end
end
