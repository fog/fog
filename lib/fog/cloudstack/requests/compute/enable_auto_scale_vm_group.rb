module Fog
  module Compute
    class Cloudstack

      class Real
        # Enables an AutoScale Vm Group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/enableAutoScaleVmGroup.html]
        def enable_auto_scale_vm_group(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'enableAutoScaleVmGroup') 
          else
            options.merge!('command' => 'enableAutoScaleVmGroup', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

