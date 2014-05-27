module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createAccount.html]
        def create_account(options={})
          options.merge!(
            'command' => 'createAccount', 
            'email' => options['email'], 
            'accounttype' => options['accounttype'], 
            'password' => options['password'], 
            'firstname' => options['firstname'], 
            'username' => options['username'], 
            'lastname' => options['lastname']  
          )
          request(options)
        end
      end

    end
  end
end

