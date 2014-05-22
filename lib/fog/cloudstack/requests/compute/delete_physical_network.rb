module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Physical Network.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deletePhysicalNetwork.html]
        def delete_physical_network(options={})
          options.merge!(
            'command' => 'deletePhysicalNetwork',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

