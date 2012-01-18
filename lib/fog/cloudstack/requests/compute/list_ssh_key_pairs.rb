module Fog
  module Compute
    class Cloudstack
      class Real

        # List registered keypairs.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listSSHKeyPairs.html]
        def list_ssh_key_pairs(options={})
          options.merge!(
            'command' => 'listSSHKeyPairs'
          )
          
          request(options)
        end

      end
    end
  end
end
