module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates an existing autoscale policy.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateAutoScalePolicy.html]
        def update_auto_scale_policy(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateAutoScalePolicy') 
          else
            options.merge!('command' => 'updateAutoScalePolicy', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

