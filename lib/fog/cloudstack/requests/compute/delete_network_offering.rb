module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a network offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteNetworkOffering.html]
        def delete_network_offering(options={})
          options.merge!(
            'command' => 'deleteNetworkOffering', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

