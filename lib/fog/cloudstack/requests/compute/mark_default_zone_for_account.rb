module Fog
  module Compute
    class Cloudstack

      class Real
        # Marks a default zone for this account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/markDefaultZoneForAccount.html]
        def mark_default_zone_for_account(options={})
          options.merge!(
            'command' => 'markDefaultZoneForAccount',
            'zoneid' => options['zoneid'], 
            'domainid' => options['domainid'], 
            'account' => options['account'], 
             
          )
          request(options)
        end
      end

    end
  end
end

