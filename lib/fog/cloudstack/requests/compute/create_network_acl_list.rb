module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Network ACL for the given VPC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createNetworkACLList.html]
        def create_network_acl_list(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createNetworkACLList') 
          else
            options.merge!('command' => 'createNetworkACLList', 
            'name' => args[0], 
            'vpcid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

