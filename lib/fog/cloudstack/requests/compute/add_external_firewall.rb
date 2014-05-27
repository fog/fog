module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds an external firewall appliance
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addExternalFirewall.html]
        def add_external_firewall(options={})
          options.merge!(
            'command' => 'addExternalFirewall', 
            'password' => options['password'], 
            'username' => options['username'], 
            'zoneid' => options['zoneid'], 
            'url' => options['url']  
          )
          request(options)
        end
      end

    end
  end
end

