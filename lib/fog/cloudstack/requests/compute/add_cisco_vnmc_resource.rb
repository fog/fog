module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Cisco Vnmc Controller
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addCiscoVnmcResource.html]
        def add_cisco_vnmc_resource(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addCiscoVnmcResource') 
          else
            options.merge!('command' => 'addCiscoVnmcResource', 
            'username' => args[0], 
            'hostname' => args[1], 
            'password' => args[2], 
            'physicalnetworkid' => args[3])
          end
          request(options)
        end
      end

    end
  end
end

