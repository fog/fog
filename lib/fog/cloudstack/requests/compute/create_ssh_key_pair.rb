module Fog
  module Compute
    class Cloudstack

      class Real
        # Create a new keypair and returns the private key
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createSSHKeyPair.html]
        def create_ssh_key_pair(name, options={})
          options.merge!(
            'command' => 'createSSHKeyPair', 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

