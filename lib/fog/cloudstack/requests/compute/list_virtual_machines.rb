module Fog
  module Compute
    class Cloudstack

      class Real
        # List the virtual machines owned by the account.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listVirtualMachines.html]
        def list_virtual_machines(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listVirtualMachines')
          else
            options.merge!('command' => 'listVirtualMachines')
          end
          # add project id if we have one
          @cloudstack_project_id ? options.merge!('projectid' => @cloudstack_project_id) : nil
          request(options)
        end
      end

      class Mock
        def list_virtual_machines(options={})
          {"listvirtualmachinesresponse" =>
            {"count" => self.data[:servers].values.size, "virtualmachine" => self.data[:servers].values}}
        end
      end
    end
  end
end

