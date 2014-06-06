module Fog
  module Compute
    class Cloudstack

      class Real
        # Update password of a host/pool on management server.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateHostPassword.html]
        def update_host_password(password, username, options={})
          options.merge!(
            'command' => 'updateHostPassword', 
            'password' => password, 
            'username' => username  
          )
          request(options)
        end
      end

    end
  end
end

