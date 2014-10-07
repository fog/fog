module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all LDAP Users
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listLdapUsers.html]
        def list_ldap_users(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listLdapUsers') 
          else
            options.merge!('command' => 'listLdapUsers')
          end
          request(options)
        end
      end

    end
  end
end

