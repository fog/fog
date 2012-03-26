module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a new SSH key pair..
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/createSSHKeyPair.html]
        def create_ssh_key_pair(name,options={})
          options.merge!(
            'command' => 'createSSHKeyPair',
            'name' => name
          )

          request(options)
        end

      end
    end
  end
end

