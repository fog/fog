module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates Network ACL list
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateNetworkACLList.html]
        def update_network_acl_list(options={})
          request(options)
        end


        def update_network_acl_list(id, options={})
          options.merge!(
            'command' => 'updateNetworkACLList', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

