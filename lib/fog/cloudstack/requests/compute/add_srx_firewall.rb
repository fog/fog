module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a SRX firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addSrxFirewall.html]
        def add_srx_firewall(username, networkdevicetype, physicalnetworkid, password, url, options={})
          options.merge!(
            'command' => 'addSrxFirewall', 
            'username' => username, 
            'networkdevicetype' => networkdevicetype, 
            'physicalnetworkid' => physicalnetworkid, 
            'password' => password, 
            'url' => url  
          )
          request(options)
        end
      end

    end
  end
end

