module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all LDAP configurations
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listLdapConfigurations.html]
        def list_ldap_configurations(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listLdapConfigurations') 
          else
            options.merge!('command' => 'listLdapConfigurations')
          end
          request(options)
        end
      end

    end
  end
end

