module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a user for an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteUser.html]
        def delete_user(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteUser') 
          else
            options.merge!('command' => 'deleteUser', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

