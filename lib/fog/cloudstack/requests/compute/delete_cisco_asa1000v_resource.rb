module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Cisco ASA 1000v appliance
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteCiscoAsa1000vResource.html]
        def delete_cisco_asa1000v_resource(resourceid, options={})
          options.merge!(
            'command' => 'deleteCiscoAsa1000vResource', 
            'resourceid' => resourceid  
          )
          request(options)
        end
      end

    end
  end
end

