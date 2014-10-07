module Fog
  module Compute
    class Cloudstack

      class Real
        # Locks a user account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/lockUser.html]
        def lock_user(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'lockUser') 
          else
            options.merge!('command' => 'lockUser', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

