module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists LBStickiness policies.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listLBStickinessPolicies.html]
        def list_lb_stickiness_policies(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listLBStickinessPolicies') 
          else
            options.merge!('command' => 'listLBStickinessPolicies')
          end
          request(options)
        end
      end

    end
  end
end

