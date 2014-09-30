module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a hypervisor capabilities.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateHypervisorCapabilities.html]
        def update_hypervisor_capabilities(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateHypervisorCapabilities') 
          else
            options.merge!('command' => 'updateHypervisorCapabilities')
          end
          request(options)
        end
      end

    end
  end
end

