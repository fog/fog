module Fog
  module Compute
    class Cloudstack

      class Real
        # Enables an AutoScale Vm Group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/enableAutoScaleVmGroup.html]
        def enable_auto_scale_vm_group(id, options={})
          options.merge!(
            'command' => 'enableAutoScaleVmGroup', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

