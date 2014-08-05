module Fog
  module Compute
    class Cloudstack

      class Real
        # List system virtual machines.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listSystemVms.html]
        def list_system_vms(options={})
          options.merge!(
            'command' => 'listSystemVms'  
          )
          request(options)
        end
      end

    end
  end
end

