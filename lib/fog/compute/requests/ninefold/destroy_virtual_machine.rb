module Fog
  module Ninefold
    class Compute
      class Real

        def destroy_virtual_machine(options = {})
          request('destroyVirtualMachine', options, :expects => [200],
                  :response_prefix => 'destroyvirtualmachineresponse', :response_type => Hash)
        end

      end
    end
  end
end
