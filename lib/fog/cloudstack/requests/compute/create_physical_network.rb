module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPhysicalNetwork.html]
        def create_physical_network(options={})
          options.merge!(
            'command' => 'createPhysicalNetwork', 
            'name' => options['name'], 
            'zoneid' => options['zoneid']  
          )
          request(options)
        end
      end

    end
  end
end

