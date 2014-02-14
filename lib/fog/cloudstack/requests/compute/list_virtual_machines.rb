  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # List the virtual machines owned by the account.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listVirtualMachines.html]
          def list_virtual_machines(options={})
            options.merge!(
              'command' => 'listVirtualMachines'
            )
            request(options)
          end
           
        end # Real

         class Mock
          def list_virtual_machines(options={})
            {"listvirtualmachinesresponse" =>
              {"count" => self.data[:servers].values.size, "virtualmachine" => self.data[:servers].values}}
          end
        end # Mock
      end # Cloudstack
    end # Compute
  end # Fog
