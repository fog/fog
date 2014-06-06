module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists LBStickiness policies.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listLBStickinessPolicies.html]
        def list_lb_stickiness_policies(lbruleid, options={})
          options.merge!(
            'command' => 'listLBStickinessPolicies', 
            'lbruleid' => lbruleid  
          )
          request(options)
        end
      end

    end
  end
end

