module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates an existing autoscale vm profile.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateAutoScaleVmProfile.html]
        def update_auto_scale_vm_profile(id, options={})
          options.merge!(
            'command' => 'updateAutoScaleVmProfile', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

