module Fog
  module Compute
    class Cloudstack

      class Real
        # Register a public key in a keypair under a certain name
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/registerSSHKeyPair.html]
        def register_ssh_key_pair(options={})
          options.merge!(
            'command' => 'registerSSHKeyPair', 
            'publickey' => options['publickey'], 
            'name' => options['name']  
          )
          request(options)
        end
      end

    end
  end
end

