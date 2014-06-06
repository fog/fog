module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Network ACL
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteNetworkACLList.html]
        def delete_network_acl_list(id, options={})
          options.merge!(
            'command' => 'deleteNetworkACLList', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

