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
            'networkdevicetype' => options['networkdevicetype'], 
            'physicalnetworkid' => options['physicalnetworkid'], 
            'password' => options['password'], 
            'url' => options['url'], 
            'username' => options['username'], 
             
          )
          request(options)
        end
      end

    end
  end
end

