module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Cisco Vnmc Controller
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addCiscoVnmcResource.html]
        def add_cisco_vnmc_resource(options={})
          request(options)
        end


        def add_cisco_vnmc_resource(username, hostname, password, physicalnetworkid, options={})
          options.merge!(
            'command' => 'addCiscoVnmcResource', 
            'username' => username, 
            'hostname' => hostname, 
            'password' => password, 
            'physicalnetworkid' => physicalnetworkid  
          )
          request(options)
        end
      end

    end
  end
end

