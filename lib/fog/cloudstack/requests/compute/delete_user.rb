module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a user for an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteUser.html]
        def delete_user(id, options={})
          options.merge!(
            'command' => 'deleteUser', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

