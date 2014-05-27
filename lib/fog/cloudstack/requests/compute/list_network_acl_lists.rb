module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all network ACLs
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listNetworkACLLists.html]
        def list_network_acl_lists(options={})
          options.merge!(
            'command' => 'listNetworkACLLists'  
          )
          request(options)
        end
      end

    end
  end
end

