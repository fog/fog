module Fog
  module Compute
    class Cloudstack

      class Real
        # associate a profile to a blade
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/associateUcsProfileToBlade.html]
        def associate_ucs_profile_to_blade(options={})
          request(options)
        end


        def associate_ucs_profile_to_blade(profiledn, ucsmanagerid, bladeid, options={})
          options.merge!(
            'command' => 'associateUcsProfileToBlade', 
            'profiledn' => profiledn, 
            'ucsmanagerid' => ucsmanagerid, 
            'bladeid' => bladeid  
          )
          request(options)
        end
      end

    end
  end
end

