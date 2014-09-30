module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates Network ACL list
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateNetworkACLList.html]
        def update_network_acl_list(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateNetworkACLList') 
          else
            options.merge!('command' => 'updateNetworkACLList', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

