module Fog
  module Compute
    class Cloudstack

      class Real
        # associate a profile to a blade
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/associateUcsProfileToBlade.html]
        def associate_ucs_profile_to_blade(options={})
          options.merge!(
            'command' => 'associateUcsProfileToBlade',
            'profiledn' => options['profiledn'], 
            'bladeid' => options['bladeid'], 
            'ucsmanagerid' => options['ucsmanagerid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

