module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Network ACL
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteNetworkACL.html]
        def delete_network_acl(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteNetworkACL') 
          else
            options.merge!('command' => 'deleteNetworkACL', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

