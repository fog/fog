module Fog
  module Compute
    class Ninefold
      class Real

        def start_virtual_machine(options = {})
          request('startVirtualMachine', options, :expects => [200],
                  :response_prefix => 'startvirtualmachineresponse', :response_type => Hash)
        end

      end
    end
  end
end
