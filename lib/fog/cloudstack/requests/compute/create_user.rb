module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a user for an account that already exists
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createUser.html]
        def create_user(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createUser') 
          else
            options.merge!('command' => 'createUser', 
            'email' => args[0], 
            'username' => args[1], 
            'lastname' => args[2], 
            'password' => args[3], 
            'firstname' => args[4], 
            'account' => args[5])
          end
          request(options)
        end
      end

    end
  end
end

