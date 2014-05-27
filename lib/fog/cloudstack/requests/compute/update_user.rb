module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a user account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateUser.html]
        def update_user(options={})
          options.merge!(
            'command' => 'updateUser', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

