module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates an existing autoscale policy.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateAutoScalePolicy.html]
        def update_auto_scale_policy(options={})
          options.merge!(
            'command' => 'updateAutoScalePolicy',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

