module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Network ACL
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteNetworkACLList.html]
        def delete_network_acl_list(options={})
          options.merge!(
            'command' => 'deleteNetworkACLList', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

