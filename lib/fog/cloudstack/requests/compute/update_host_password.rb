module Fog
  module Compute
    class Cloudstack

      class Real
        # Update password of a host/pool on management server.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateHostPassword.html]
        def update_host_password(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateHostPassword') 
          else
            options.merge!('command' => 'updateHostPassword', 
            'username' => args[0], 
            'password' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

