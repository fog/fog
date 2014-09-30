module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createAccount.html]
        def create_account(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createAccount') 
          else
            options.merge!('command' => 'createAccount', 
            'accounttype' => args[0], 
            'lastname' => args[1], 
            'email' => args[2], 
            'firstname' => args[3], 
            'username' => args[4], 
            'password' => args[5])
          end
          request(options)
        end
      end

    end
  end
end

