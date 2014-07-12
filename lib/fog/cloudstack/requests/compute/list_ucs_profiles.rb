module Fog
  module Compute
    class Cloudstack

      class Real
        # List profile in ucs manager
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listUcsProfiles.html]
        def list_ucs_profiles(ucsmanagerid, options={})
          options.merge!(
            'command' => 'listUcsProfiles', 
            'ucsmanagerid' => ucsmanagerid  
          )
          request(options)
        end
      end

    end
  end
end

