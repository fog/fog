module Fog
  module Compute
    class Cloudstack

      class Real
        # Enables a user account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/enableUser.html]
        def enable_user(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'enableUser') 
          else
            options.merge!('command' => 'enableUser', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

