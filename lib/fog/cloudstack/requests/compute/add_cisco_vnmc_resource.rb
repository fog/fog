module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Cisco Vnmc Controller
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addCiscoVnmcResource.html]
        def add_cisco_vnmc_resource(options={})
          options.merge!(
            'command' => 'addCiscoVnmcResource',
            'hostname' => options['hostname'], 
            'password' => options['password'], 
            'username' => options['username'], 
            'physicalnetworkid' => options['physicalnetworkid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

