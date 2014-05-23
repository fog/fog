module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a user for an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteUser.html]
        def delete_user(options={})
          options.merge!(
            'command' => 'deleteUser',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

