module Fog
  module Compute
    class Cloudstack

      class Real
        # Reboots a system VM.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/rebootSystemVm.html]
        def reboot_system_vm(options={})
          options.merge!(
            'command' => 'rebootSystemVm', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

