module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists autoscale vm groups.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listAutoScaleVmGroups.html]
        def list_auto_scale_vm_groups(options={})
          options.merge!(
            'command' => 'listAutoScaleVmGroups'  
          )
          request(options)
        end
      end

    end
  end
end

