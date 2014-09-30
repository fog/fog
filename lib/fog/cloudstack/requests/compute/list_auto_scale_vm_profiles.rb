module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists autoscale vm profiles.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listAutoScaleVmProfiles.html]
        def list_auto_scale_vm_profiles(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listAutoScaleVmProfiles') 
          else
            options.merge!('command' => 'listAutoScaleVmProfiles')
          end
          request(options)
        end
      end

    end
  end
end

