module Fog
  module Compute
    class Cloudstack

      class Real
        # This command allows a user to register for the developer API, returning a secret key and an API key. This request is made through the integration API port, so it is a privileged command and must be made on behalf of a user. It is up to the implementer just how the username and password are entered, and then how that translates to an integration API request. Both secret key and API key should be returned to the user
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/registerUserKeys.html]
        def register_user_keys(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'registerUserKeys') 
          else
            options.merge!('command' => 'registerUserKeys', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

