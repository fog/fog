module Fog
  module Ninefold
    class Compute
      class Real

        def destroy_virtual_machine(options = {})
          request('destroyVirtualMachine', options, :expects => [200],
                  :response_prefix => 'destroyvirtualmachineresponse', :response_type => Hash)
        end

      end

      class Mock

        def destroy_virtual_machine(*args)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
