module Fog
  module Compute
    class Cloudstack

      class Real
        # Register a public key in a keypair under a certain name
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/registerSSHKeyPair.html]
        def register_ssh_key_pair(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'registerSSHKeyPair')
          else
            options.merge!('command' => 'registerSSHKeyPair',
            'name' => args[0],
            'publickey' => args[1])
          end
          # add project id if we have one
          @cloudstack_project_id ? options.merge!('projectid' => @cloudstack_project_id) : nil
          request(options)
        end
      end

    end
  end
end

