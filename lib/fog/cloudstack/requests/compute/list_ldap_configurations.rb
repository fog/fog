module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all LDAP configurations
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listLdapConfigurations.html]
        def list_ldap_configurations(options={})
          request(options)
        end


        def list_ldap_configurations(options={})
          options.merge!(
            'command' => 'listLdapConfigurations'  
          )
          request(options)
        end
      end

    end
  end
end

