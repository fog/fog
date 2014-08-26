module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Palo Alto firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addPaloAltoFirewall.html]
        def add_palo_alto_firewall(options={})
          request(options)
        end


        def add_palo_alto_firewall(username, networkdevicetype, password, physicalnetworkid, url, options={})
          options.merge!(
            'command' => 'addPaloAltoFirewall', 
            'username' => username, 
            'networkdevicetype' => networkdevicetype, 
            'password' => password, 
            'physicalnetworkid' => physicalnetworkid, 
            'url' => url  
          )
          request(options)
        end
      end

    end
  end
end

