module Fog
  module Compute
    class Cloudstack

      class Real
        # Create a new keypair and returns the private key
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createSSHKeyPair.html]
        def create_ssh_key_pair(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createSSHKeyPair')
          else
            options.merge!('command' => 'createSSHKeyPair',
            'name' => args[0])
          end
          # add project id if we have one
          @cloudstack_project_id ? options.merge!('projectid' => @cloudstack_project_id) : nil
          request(options)
        end
      end

    end
  end
end

