module Fog
  module Compute
    class Cloudstack

      class Real
        # List registered keypairs
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listSSHKeyPairs.html]
        def list_ssh_key_pairs(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listSSHKeyPairs') 
          else
            options.merge!('command' => 'listSSHKeyPairs')
          end
          request(options)
        end
      end

    end
  end
end

