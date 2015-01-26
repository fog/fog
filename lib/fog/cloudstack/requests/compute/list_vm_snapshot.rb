module Fog
  module Compute
    class Cloudstack

      class Real
        # List virtual machine snapshot by conditions
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listVMSnapshot.html]
        def list_vm_snapshot(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listVMSnapshot')
          else
            options.merge!('command' => 'listVMSnapshot')
          end
          # add project id if we have one
          @cloudstack_project_id ? options.merge!('projectid' => @cloudstack_project_id) : nil
          request(options)
        end
      end

    end
  end
end

