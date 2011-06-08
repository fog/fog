module Fog
  module Ninefold
    class Compute
      class Real

        def change_service_for_virtual_machine(options = {})
          request('changeServiceForVirtualMachine', options, :expects => [200],
                  :response_prefix => 'changeserviceforvirtualmachineresponse/virtualmachine', :response_type => Hash)
        end

      end
    end
  end
end
