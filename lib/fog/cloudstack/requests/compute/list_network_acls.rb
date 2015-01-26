module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all network ACL items
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listNetworkACLs.html]
        def list_network_acls(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listNetworkACLs') 
          else
            options.merge!('command' => 'listNetworkACLs')
          end
          request(options)
        end
      end

    end
  end
end

