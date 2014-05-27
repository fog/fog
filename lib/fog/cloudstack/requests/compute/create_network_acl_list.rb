module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Network ACL for the given VPC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createNetworkACLList.html]
        def create_network_acl_list(options={})
          options.merge!(
            'command' => 'createNetworkACLList', 
            'vpcid' => options['vpcid'], 
            'name' => options['name']  
          )
          request(options)
        end
      end

    end
  end
end

