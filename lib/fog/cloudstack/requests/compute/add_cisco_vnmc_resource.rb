module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Cisco Vnmc Controller
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addCiscoVnmcResource.html]
        def add_cisco_vnmc_resource(physicalnetworkid, hostname, password, username, options={})
          options.merge!(
            'command' => 'addCiscoVnmcResource', 
            'physicalnetworkid' => physicalnetworkid, 
            'hostname' => hostname, 
            'password' => password, 
            'username' => username  
          )
          request(options)
        end
      end

    end
  end
end

