module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Cisco Vnmc controller
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteCiscoVnmcResource.html]
        def delete_cisco_vnmc_resource(resourceid, options={})
          options.merge!(
            'command' => 'deleteCiscoVnmcResource', 
            'resourceid' => resourceid  
          )
          request(options)
        end
      end

    end
  end
end

