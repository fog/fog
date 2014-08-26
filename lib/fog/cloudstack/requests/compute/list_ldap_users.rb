module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all LDAP Users
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listLdapUsers.html]
        def list_ldap_users(options={})
          request(options)
        end


        def list_ldap_users(options={})
          options.merge!(
            'command' => 'listLdapUsers'  
          )
          request(options)
        end
      end

    end
  end
end

