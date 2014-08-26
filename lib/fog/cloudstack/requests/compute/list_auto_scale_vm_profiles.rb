module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists autoscale vm profiles.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listAutoScaleVmProfiles.html]
        def list_auto_scale_vm_profiles(options={})
          options.merge!(
            'command' => 'listAutoScaleVmProfiles'  
          )
          request(options)
        end
      end

    end
  end
end

