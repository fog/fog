module Fog
  module Compute
    class Cloudstack

      class Real
        # Add a new Ldap Configuration
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addLdapConfiguration.html]
        def add_ldap_configuration(options={})
          request(options)
        end


        def add_ldap_configuration(port, hostname, options={})
          options.merge!(
            'command' => 'addLdapConfiguration', 
            'port' => port, 
            'hostname' => hostname  
          )
          request(options)
        end
      end

    end
  end
end

