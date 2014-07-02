module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists autoscale policies.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listAutoScalePolicies.html]
        def list_auto_scale_policies(options={})
          options.merge!(
            'command' => 'listAutoScalePolicies'  
          )
          request(options)
        end
      end

    end
  end
end

