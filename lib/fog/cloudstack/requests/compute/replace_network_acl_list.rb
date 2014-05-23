module Fog
  module Compute
    class Cloudstack

      class Real
        # Replaces ACL associated with a Network or private gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/replaceNetworkACLList.html]
        def replace_network_acl_list(options={})
          options.merge!(
            'command' => 'replaceNetworkACLList',
            'aclid' => options['aclid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

