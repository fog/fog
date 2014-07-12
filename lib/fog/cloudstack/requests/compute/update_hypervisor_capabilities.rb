module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a hypervisor capabilities.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateHypervisorCapabilities.html]
        def update_hypervisor_capabilities(options={})
          options.merge!(
            'command' => 'updateHypervisorCapabilities'  
          )
          request(options)
        end
      end

    end
  end
end

