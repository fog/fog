module Fog
  module Compute
    class Cloudstack

      class Real
        # associate a profile to a blade
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/associateUcsProfileToBlade.html]
        def associate_ucs_profile_to_blade(bladeid, profiledn, ucsmanagerid, options={})
          options.merge!(
            'command' => 'associateUcsProfileToBlade', 
            'bladeid' => bladeid, 
            'profiledn' => profiledn, 
            'ucsmanagerid' => ucsmanagerid  
          )
          request(options)
        end
      end

    end
  end
end

