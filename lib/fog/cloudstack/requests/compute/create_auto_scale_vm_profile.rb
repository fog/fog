module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a profile that contains information about the virtual machine which will be provisioned automatically by autoscale feature.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createAutoScaleVmProfile.html]
        def create_auto_scale_vm_profile(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createAutoScaleVmProfile') 
          else
            options.merge!('command' => 'createAutoScaleVmProfile', 
            'templateid' => args[0], 
            'zoneid' => args[1], 
            'serviceofferingid' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

