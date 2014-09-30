module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates LB Stickiness policy
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateLBStickinessPolicy.html]
        def update_lb_stickiness_policy(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateLBStickinessPolicy') 
          else
            options.merge!('command' => 'updateLBStickinessPolicy', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

