module Fog
  module Compute
    class Cloudstack

      class Real
        # List registered keypairs
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listSSHKeyPairs.html]
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

