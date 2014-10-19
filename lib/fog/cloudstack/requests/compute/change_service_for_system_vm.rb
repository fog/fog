module Fog
  module Compute
    class Cloudstack

      class Real
        # Changes the service offering for a system vm (console proxy or secondary storage). The system vm must be in a "Stopped" state for this command to take effect.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/changeServiceForSystemVm.html]
        def change_service_for_system_vm(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'changeServiceForSystemVm') 
          else
            options.merge!('command' => 'changeServiceForSystemVm', 
            'id' => args[0], 
            'serviceofferingid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

