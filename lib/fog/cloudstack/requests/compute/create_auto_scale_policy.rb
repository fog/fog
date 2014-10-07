module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an autoscale policy for a provision or deprovision action, the action is taken when the all the conditions evaluates to true for the specified duration. The policy is in effect once it is attached to a autscale vm group.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createAutoScalePolicy.html]
        def create_auto_scale_policy(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createAutoScalePolicy') 
          else
            options.merge!('command' => 'createAutoScalePolicy', 
            'duration' => args[0], 
            'conditionids' => args[1], 
            'action' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

