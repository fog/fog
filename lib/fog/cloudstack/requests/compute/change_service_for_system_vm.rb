module Fog
  module Compute
    class Cloudstack

      class Real
        # Changes the service offering for a system vm (console proxy or secondary storage). The system vm must be in a "Stopped" state for this command to take effect.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/changeServiceForSystemVm.html]
        def change_service_for_system_vm(options={})
          options.merge!(
            'command' => 'changeServiceForSystemVm', 
            'serviceofferingid' => options['serviceofferingid'], 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

