  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # List registered keypairs
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listSSHKeyPairs.html]
          def list_sshkey_pairs(options={})
            options.merge!(
              'command' => 'listSSHKeyPairs'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
