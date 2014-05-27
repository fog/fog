module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Load Balancer stickiness policy 
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createLBStickinessPolicy.html]
        def create_lb_stickiness_policy(options={})
          options.merge!(
            'command' => 'createLBStickinessPolicy', 
            'lbruleid' => options['lbruleid'], 
            'methodname' => options['methodname'], 
            'name' => options['name']  
          )
          request(options)
        end
      end

    end
  end
end

