module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an account from an LDAP user
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/ldapCreateAccount.html]
        def ldap_create_account(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'ldapCreateAccount') 
          else
            options.merge!('command' => 'ldapCreateAccount', 
            'username' => args[0], 
            'accounttype' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

