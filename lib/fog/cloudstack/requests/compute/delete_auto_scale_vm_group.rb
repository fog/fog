module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a autoscale vm group.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteAutoScaleVmGroup.html]
        def delete_auto_scale_vm_group(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteAutoScaleVmGroup') 
          else
            options.merge!('command' => 'deleteAutoScaleVmGroup', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

