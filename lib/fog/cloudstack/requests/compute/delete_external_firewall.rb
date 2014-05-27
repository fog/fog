module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes an external firewall appliance.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteExternalFirewall.html]
        def delete_external_firewall(options={})
          options.merge!(
            'command' => 'deleteExternalFirewall', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

