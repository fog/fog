module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createAccount.html]
        def create_account(options={})
          request(options)
        end


        def create_account(accounttype, lastname, email, firstname, username, password, options={})
          options.merge!(
            'command' => 'createAccount', 
            'accounttype' => accounttype, 
            'lastname' => lastname, 
            'email' => email, 
            'firstname' => firstname, 
            'username' => username, 
            'password' => password  
          )
          request(options)
        end
      end

    end
  end
end

