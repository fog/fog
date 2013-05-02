  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a keypair by name
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteSSHKeyPair.html]
          def delete_sshkey_pair(options={})
            options.merge!(
              'command' => 'deleteSSHKeyPair'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
