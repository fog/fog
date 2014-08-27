module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all hypervisor capabilities.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listHypervisorCapabilities.html]
        def list_hypervisor_capabilities(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listHypervisorCapabilities') 
          else
            options.merge!('command' => 'listHypervisorCapabilities')
          end
          request(options)
        end
      end

    end
  end
end

