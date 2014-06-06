module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a profile that contains information about the virtual machine which will be provisioned automatically by autoscale feature.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createAutoScaleVmProfile.html]
        def create_auto_scale_vm_profile(serviceofferingid, templateid, zoneid, options={})
          options.merge!(
            'command' => 'createAutoScaleVmProfile', 
            'serviceofferingid' => serviceofferingid, 
            'templateid' => templateid, 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

