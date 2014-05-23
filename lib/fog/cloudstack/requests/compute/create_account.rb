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
            'firstname' => options['firstname'], 
            'password' => options['password'], 
            'accounttype' => options['accounttype'], 
            'username' => options['username'], 
            'email' => options['email'], 
            'lastname' => options['lastname'], 
             
          )
          request(options)
        end
      end

    end
  end
end

