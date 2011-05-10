module Fog
  module Ninefold
    class Compute
      class Real

        def reset_password_for_virtual_machine(options = {})
          request('resetPasswordForVirtualMachine', options, :expects => [200],
                  :response_prefix => 'resetpasswordforvirtualmachineresponse', :response_type => Hash)
        end

      end

      class Mock

        def change_service_for_virtual_machine(*args)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
