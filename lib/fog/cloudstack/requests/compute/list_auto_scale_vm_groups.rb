module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists autoscale vm groups.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listAutoScaleVmGroups.html]
        def list_auto_scale_vm_groups(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listAutoScaleVmGroups') 
          else
            options.merge!('command' => 'listAutoScaleVmGroups')
          end
          request(options)
        end
      end

    end
  end
end

