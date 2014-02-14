  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Remove the LDAP context for this site.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/ldapRemove.html]
          def ldap_remove(options={})
            options.merge!(
              'command' => 'ldapRemove'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
