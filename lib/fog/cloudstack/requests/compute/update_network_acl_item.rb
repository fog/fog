module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates ACL Item with specified Id
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateNetworkACLItem.html]
        def update_network_acl_item(id, options={})
          options.merge!(
            'command' => 'updateNetworkACLItem', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

