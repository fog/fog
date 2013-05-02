  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Register a public key in a keypair under a certain name
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/registerSSHKeyPair.html]
          def register_sshkey_pair(options={})
            options.merge!(
              'command' => 'registerSSHKeyPair'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
