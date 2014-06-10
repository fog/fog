module Fog
  module Compute
    class Ninefold
      class Real
        def deploy_virtual_machine(options = {})
          request('deployVirtualMachine', options, :expects => [200],
                  :response_prefix => 'deployvirtualmachineresponse', :response_type => Hash)
        end
      end
    end
  end
end
