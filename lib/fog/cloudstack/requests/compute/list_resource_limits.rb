module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists resource limits.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listResourceLimits.html]
        def list_resource_limits(options={})
          options.merge!(
            'command' => 'listResourceLimits'
          )
          
          request(options)
        end

      end
    end
  end
end
