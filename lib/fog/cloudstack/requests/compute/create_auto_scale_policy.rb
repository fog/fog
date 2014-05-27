module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an autoscale policy for a provision or deprovision action, the action is taken when the all the conditions evaluates to true for the specified duration. The policy is in effect once it is attached to a autscale vm group.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createAutoScalePolicy.html]
        def create_auto_scale_policy(options={})
          options.merge!(
            'command' => 'createAutoScalePolicy', 
            'conditionids' => options['conditionids'], 
            'action' => options['action'], 
            'duration' => options['duration']  
          )
          request(options)
        end
      end

    end
  end
end

