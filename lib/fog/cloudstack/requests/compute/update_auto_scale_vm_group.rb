module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates an existing autoscale vm group.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateAutoScaleVmGroup.html]
        def update_auto_scale_vm_group(id, options={})
          options.merge!(
            'command' => 'updateAutoScaleVmGroup', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

