module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a profile that contains information about the virtual machine which will be provisioned automatically by autoscale feature.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createAutoScaleVmProfile.html]
        def create_auto_scale_vm_profile(options={})
          request(options)
        end


        def create_auto_scale_vm_profile(templateid, zoneid, serviceofferingid, options={})
          options.merge!(
            'command' => 'createAutoScaleVmProfile', 
            'templateid' => templateid, 
            'zoneid' => zoneid, 
            'serviceofferingid' => serviceofferingid  
          )
          request(options)
        end
      end

    end
  end
end

