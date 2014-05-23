module Fog
  module Compute
    class Cloudstack

      class Real
        # disassociate a profile from a blade
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/disassociateUcsProfileFromBlade.html]
        def disassociate_ucs_profile_from_blade(options={})
          options.merge!(
            'command' => 'disassociateUcsProfileFromBlade',
            'bladeid' => options['bladeid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

