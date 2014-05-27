module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a SRX firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addSrxFirewall.html]
        def add_srx_firewall(options={})
          options.merge!(
            'command' => 'addSrxFirewall', 
            'url' => options['url'], 
            'networkdevicetype' => options['networkdevicetype'], 
            'password' => options['password'], 
            'username' => options['username'], 
            'physicalnetworkid' => options['physicalnetworkid']  
          )
          request(options)
        end
      end

    end
  end
end

