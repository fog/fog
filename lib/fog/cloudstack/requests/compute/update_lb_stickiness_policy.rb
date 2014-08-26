module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates LB Stickiness policy
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateLBStickinessPolicy.html]
        def update_lb_stickiness_policy(options={})
          request(options)
        end


        def update_lb_stickiness_policy(id, options={})
          options.merge!(
            'command' => 'updateLBStickinessPolicy', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

