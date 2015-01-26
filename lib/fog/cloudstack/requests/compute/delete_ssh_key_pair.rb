module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a keypair by name
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteSSHKeyPair.html]
        def delete_ssh_key_pair(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteSSHKeyPair')
          else
            options.merge!('command' => 'deleteSSHKeyPair',
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

