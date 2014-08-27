module Fog
  module Compute
    class Cloudstack

      class Real
        # Remove an Ldap Configuration
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteLdapConfiguration.html]
        def delete_ldap_configuration(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteLdapConfiguration') 
          else
            options.merge!('command' => 'deleteLdapConfiguration', 
            'hostname' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

