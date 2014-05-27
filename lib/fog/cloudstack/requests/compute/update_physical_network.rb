module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updatePhysicalNetwork.html]
        def update_physical_network(options={})
          options.merge!(
            'command' => 'updatePhysicalNetwork', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

