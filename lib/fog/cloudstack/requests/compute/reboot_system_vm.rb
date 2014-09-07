module Fog
  module Compute
    class Cloudstack

      class Real
        # Reboots a system VM.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/rebootSystemVm.html]
        def reboot_system_vm(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'rebootSystemVm') 
          else
            options.merge!('command' => 'rebootSystemVm', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

