module Fog
  module Compute
    class Cloudstack
      class Real

        # Deletes a keypair by name
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.12/global_admin/deleteSSHKeyPair.html]
        def delete_ssh_key_pair(name,options={})
          options.merge!(
            'command' => 'deleteSSHKeyPair',
            'name' => name
          )

          request(options)
        end

      end
    end
  end
end
