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
            'username' => options['username'], 
            'url' => options['url'], 
            'password' => options['password'], 
            'zoneid' => options['zoneid']  
          )
          request(options)
        end
      end

    end
  end
end

