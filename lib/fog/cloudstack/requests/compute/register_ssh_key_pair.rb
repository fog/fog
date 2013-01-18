module Fog
  module Compute
    class Cloudstack
      class Real

        # Registers an SSH key pair..
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/registerSSHKeyPair.html]
        def register_ssh_key_pair(options={})
          options.merge!(
            'command' => 'registerSSHKeyPair'
          )
          request(options)
        end

      end
    end
  end
end

