module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteNetwork.html]
        def delete_network(id, options={})
          options.merge!(
            'command' => 'deleteNetwork', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

