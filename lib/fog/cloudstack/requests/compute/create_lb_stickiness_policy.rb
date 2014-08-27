module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Load Balancer stickiness policy 
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createLBStickinessPolicy.html]
        def create_lb_stickiness_policy(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createLBStickinessPolicy') 
          else
            options.merge!('command' => 'createLBStickinessPolicy', 
            'methodname' => args[0], 
            'name' => args[1], 
            'lbruleid' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

