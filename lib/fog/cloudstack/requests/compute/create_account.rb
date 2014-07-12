module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createAccount.html]
        def create_account(password, lastname, accounttype, username, email, firstname, options={})
          options.merge!(
            'command' => 'createAccount', 
            'password' => password, 
            'lastname' => lastname, 
            'accounttype' => accounttype, 
            'username' => username, 
            'email' => email, 
            'firstname' => firstname  
          )
          request(options)
        end
      end

    end
  end
end

