module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a user for an account that already exists
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createUser.html]
        def create_user(options={})
          request(options)
        end


        def create_user(email, username, lastname, password, firstname, account, options={})
          options.merge!(
            'command' => 'createUser', 
            'email' => email, 
            'username' => username, 
            'lastname' => lastname, 
            'password' => password, 
            'firstname' => firstname, 
            'account' => account  
          )
          request(options)
        end
      end

    end
  end
end

