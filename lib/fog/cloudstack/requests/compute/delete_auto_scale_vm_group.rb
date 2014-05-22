module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a autoscale vm group.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteAutoScaleVmGroup.html]
        def delete_auto_scale_vm_group(options={})
          options.merge!(
            'command' => 'deleteAutoScaleVmGroup',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

