module Fog
  module Compute
    class Cloudstack

      class Real
        # Starts a system virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/startSystemVm.html]
        def start_system_vm(id, options={})
          options.merge!(
            'command' => 'startSystemVm', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

