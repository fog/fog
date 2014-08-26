module Fog
  module Compute
    class Cloudstack

      class Real
        # Register a public key in a keypair under a certain name
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/registerSSHKeyPair.html]
        def register_ssh_key_pair(options={})
          request(options)
        end


        def register_ssh_key_pair(name, publickey, options={})
          options.merge!(
            'command' => 'registerSSHKeyPair', 
            'name' => name, 
            'publickey' => publickey  
          )
          request(options)
        end
      end

    end
  end
end

