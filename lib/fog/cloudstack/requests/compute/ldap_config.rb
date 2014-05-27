module Fog
  module Compute
    class Cloudstack

      class Real
        # Configure the LDAP context for this site.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/ldapConfig.html]
        def ldap_config(options={})
          options.merge!(
            'command' => 'ldapConfig'  
          )
          request(options)
        end
      end

    end
  end
end

