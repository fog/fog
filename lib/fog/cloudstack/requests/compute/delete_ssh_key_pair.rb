module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a keypair by name
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteSSHKeyPair.html]
        def delete_ssh_key_pair(name, options={})
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

