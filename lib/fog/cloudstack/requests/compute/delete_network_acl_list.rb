module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Network ACL
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteNetworkACLList.html]
        def delete_network_acl_list(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteNetworkACLList') 
          else
            options.merge!('command' => 'deleteNetworkACLList', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

