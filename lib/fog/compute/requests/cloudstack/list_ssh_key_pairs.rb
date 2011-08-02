module Fog
  module Compute
    class Cloudstack
      class Real

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
