  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Create a new keypair and returns the private key
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createSSHKeyPair.html]
          def create_sshkey_pair(options={})
            options.merge!(
              'command' => 'createSSHKeyPair'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
