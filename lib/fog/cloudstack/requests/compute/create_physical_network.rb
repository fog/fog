module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPhysicalNetwork.html]
        def create_physical_network(zoneid, name, options={})
          options.merge!(
            'command' => 'createPhysicalNetwork', 
            'zoneid' => zoneid, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

