module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists Cisco VNMC controllers
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listCiscoVnmcResources.html]
        def list_cisco_vnmc_resources(options={})
          options.merge!(
            'command' => 'listCiscoVnmcResources'  
          )
          request(options)
        end
      end

    end
  end
end

