module Fog
  module Compute
    class Ninefold
      class Real

        def reset_password_for_virtual_machine(options = {})
          request('resetPasswordForVirtualMachine', options, :expects => [200],
                  :response_prefix => 'resetpasswordforvirtualmachineresponse', :response_type => Hash)
        end

      end
    end
  end
end
