module Fog
  module Compute
    class Cloudstack

      class Real
        # Import LDAP users
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/importLdapUsers.html]
        def import_ldap_users(options={})
          request(options)
        end


        def import_ldap_users(accounttype, options={})
          options.merge!(
            'command' => 'importLdapUsers', 
            'accounttype' => accounttype  
          )
          request(options)
        end
      end

    end
  end
end

