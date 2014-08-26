module Fog
  module Compute
    class Cloudstack

      class Real
        # Remove an Ldap Configuration
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteLdapConfiguration.html]
        def delete_ldap_configuration(options={})
          request(options)
        end


        def delete_ldap_configuration(hostname, options={})
          options.merge!(
            'command' => 'deleteLdapConfiguration', 
            'hostname' => hostname  
          )
          request(options)
        end
      end

    end
  end
end

