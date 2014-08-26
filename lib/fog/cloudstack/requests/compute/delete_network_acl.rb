module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Network ACL
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteNetworkACL.html]
        def delete_network_acl(id, options={})
          options.merge!(
            'command' => 'deleteNetworkACL', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

