module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Load Balancer stickiness policy 
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createLBStickinessPolicy.html]
        def create_lb_stickiness_policy(options={})
          request(options)
        end


        def create_lb_stickiness_policy(methodname, name, lbruleid, options={})
          options.merge!(
            'command' => 'createLBStickinessPolicy', 
            'methodname' => methodname, 
            'name' => name, 
            'lbruleid' => lbruleid  
          )
          request(options)
        end
      end

    end
  end
end

