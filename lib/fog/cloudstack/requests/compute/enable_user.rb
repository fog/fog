module Fog
  module Compute
    class Cloudstack

      class Real
        # Enables a user account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/enableUser.html]
        def enable_user(id, options={})
          options.merge!(
            'command' => 'enableUser', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

