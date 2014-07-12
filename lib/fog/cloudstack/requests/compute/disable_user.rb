module Fog
  module Compute
    class Cloudstack

      class Real
        # Disables a user account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/disableUser.html]
        def disable_user(id, options={})
          options.merge!(
            'command' => 'disableUser', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

