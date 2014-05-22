module Fog
  module Compute
    class Cloudstack

      class Real
        # Disables an AutoScale Vm Group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/disableAutoScaleVmGroup.html]
        def disable_auto_scale_vm_group(options={})
          options.merge!(
            'command' => 'disableAutoScaleVmGroup',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

