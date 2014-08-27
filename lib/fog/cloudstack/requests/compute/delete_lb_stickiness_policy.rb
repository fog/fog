module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a LB stickiness policy.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteLBStickinessPolicy.html]
        def delete_lb_stickiness_policy(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteLBStickinessPolicy') 
          else
            options.merge!('command' => 'deleteLBStickinessPolicy', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

