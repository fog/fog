module Fog
  module Compute
    class Cloudstack
      class Real
        def assign_virtual_machine(options={})
          options.merge!('command' => 'assignVirtualMachine')

          request(options)
        end
      end
      class Mock
        # Fog::Compute::Cloudstack::Error: Failed to move vm VM is Running, unable to move the vm VM[User|e845934a-e44f-43da-aabf-05c90c651756]
        #def assign_virtual_machine(options={})
        #end
      end
    end
  end
end
