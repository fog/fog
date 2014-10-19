module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists autoscale policies.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listAutoScalePolicies.html]
        def list_auto_scale_policies(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listAutoScalePolicies') 
          else
            options.merge!('command' => 'listAutoScalePolicies')
          end
          request(options)
        end
      end

    end
  end
end

