module Fog
  module Compute
    class Cloudstack

      class Real
        # Locks a user account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/lockUser.html]
        def lock_user(id, options={})
          options.merge!(
            'command' => 'lockUser', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

