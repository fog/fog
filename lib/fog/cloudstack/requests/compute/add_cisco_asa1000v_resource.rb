module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Cisco Asa 1000v appliance
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addCiscoAsa1000vResource.html]
        def add_cisco_asa1000v_resource(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addCiscoAsa1000vResource') 
          else
            options.merge!('command' => 'addCiscoAsa1000vResource', 
            'hostname' => args[0], 
            'physicalnetworkid' => args[1], 
            'insideportprofile' => args[2], 
            'clusterid' => args[3])
          end
          request(options)
        end
      end

    end
  end
end

