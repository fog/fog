module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an account from an LDAP user
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/ldapCreateAccount.html]
        def ldap_create_account(options={})
          request(options)
        end


        def ldap_create_account(username, accounttype, options={})
          options.merge!(
            'command' => 'ldapCreateAccount', 
            'username' => username, 
            'accounttype' => accounttype  
          )
          request(options)
        end
      end

    end
  end
end

