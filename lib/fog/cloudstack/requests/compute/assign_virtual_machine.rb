  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Move a user VM to another user under same domain.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/assignVirtualMachine.html]
          def assign_virtual_machine(options={})
            options.merge!(
              'command' => 'assignVirtualMachine'
            )
            request(options)
          end
           
        end # Real

        class Mock
          # Fog::Compute::Cloudstack::Error: Failed to move vm VM is Running, unable to move the vm VM[User|e845934a-e44f-43da-aabf-05c90c651756]
          #def assign_virtual_machine(options={})
          #end
        end # Mock

      end # Cloudstack
    end # Compute
  end # Fog
