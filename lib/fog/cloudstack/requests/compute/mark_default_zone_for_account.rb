module Fog
  module Compute
    class Cloudstack

      class Real
        # Marks a default zone for this account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/markDefaultZoneForAccount.html]
        def mark_default_zone_for_account(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'markDefaultZoneForAccount') 
          else
            options.merge!('command' => 'markDefaultZoneForAccount', 
            'zoneid' => args[0], 
            'account' => args[1], 
            'domainid' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

