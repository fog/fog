module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all network ACLs
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listNetworkACLLists.html]
        def list_network_acl_lists(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listNetworkACLLists') 
          else
            options.merge!('command' => 'listNetworkACLLists')
          end
          request(options)
        end
      end

    end
  end
end

