module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Cisco Asa 1000v appliance
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addCiscoAsa1000vResource.html]
        def add_cisco_asa1000v_resource(options={})
          options.merge!(
            'command' => 'addCiscoAsa1000vResource', 
            'clusterid' => options['clusterid'], 
            'physicalnetworkid' => options['physicalnetworkid'], 
            'hostname' => options['hostname'], 
            'insideportprofile' => options['insideportprofile']  
          )
          request(options)
        end
      end

    end
  end
end

