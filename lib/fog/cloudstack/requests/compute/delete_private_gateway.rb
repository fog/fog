module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Private gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deletePrivateGateway.html]
        def delete_private_gateway(id, options={})
          options.merge!(
            'command' => 'deletePrivateGateway', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

