module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a ACL rule in the given network (the network has to belong to VPC)
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createNetworkACL.html]
        def create_network_acl(protocol, options={})
          options.merge!(
            'command' => 'createNetworkACL', 
            'protocol' => protocol  
          )
          request(options)
        end
      end

    end
  end
end

