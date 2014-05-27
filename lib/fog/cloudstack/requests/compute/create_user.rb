module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a user for an account that already exists
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createUser.html]
        def create_user(options={})
          options.merge!(
            'command' => 'createUser', 
            'lastname' => options['lastname'], 
            'account' => options['account'], 
            'username' => options['username'], 
            'password' => options['password'], 
            'firstname' => options['firstname'], 
            'email' => options['email']  
          )
          request(options)
        end
      end

    end
  end
end

