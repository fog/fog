module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates an existing autoscale vm profile.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateAutoScaleVmProfile.html]
        def update_auto_scale_vm_profile(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateAutoScaleVmProfile') 
          else
            options.merge!('command' => 'updateAutoScaleVmProfile', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

