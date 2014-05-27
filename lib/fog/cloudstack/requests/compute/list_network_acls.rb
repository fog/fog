module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all network ACL items
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listNetworkACLs.html]
        def list_network_acls(options={})
          options.merge!(
            'command' => 'listNetworkACLs'  
          )
          request(options)
        end
      end

    end
  end
end

