module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a autoscale vm profile.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteAutoScaleVmProfile.html]
        def delete_auto_scale_vm_profile(options={})
          options.merge!(
            'command' => 'deleteAutoScaleVmProfile',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

