module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a LB stickiness policy.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteLBStickinessPolicy.html]
        def delete_lb_stickiness_policy(options={})
          options.merge!(
            'command' => 'deleteLBStickinessPolicy',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

