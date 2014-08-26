module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a user for an account that already exists
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createUser.html]
        def create_user(username, email, firstname, lastname, password, account, options={})
          options.merge!(
            'command' => 'createUser', 
            'username' => username, 
            'email' => email, 
            'firstname' => firstname, 
            'lastname' => lastname, 
            'password' => password, 
            'account' => account  
          )
          request(options)
        end
      end

    end
  end
end

