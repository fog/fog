  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Marks a default zone for this account
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/markDefaultZoneForAccount.html]
          def mark_default_zone_for_account(options={})
            options.merge!(
              'command' => 'markDefaultZoneForAccount'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
