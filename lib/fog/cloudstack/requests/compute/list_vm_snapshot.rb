module Fog
  module Compute
    class Cloudstack

      class Real
        # List virtual machine snapshot by conditions
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listVMSnapshot.html]
        def list_vm_snapshot(options={})
          options.merge!(
            'command' => 'listVMSnapshot'  
          )
          request(options)
        end
      end

    end
  end
end

