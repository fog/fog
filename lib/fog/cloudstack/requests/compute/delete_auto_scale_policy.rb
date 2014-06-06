module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a autoscale policy.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteAutoScalePolicy.html]
        def delete_auto_scale_policy(id, options={})
          options.merge!(
            'command' => 'deleteAutoScalePolicy', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

