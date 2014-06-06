module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a Pod.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/dedicatePod.html]
        def dedicate_pod(domainid, podid, options={})
          options.merge!(
            'command' => 'dedicatePod', 
            'domainid' => domainid, 
            'podid' => podid  
          )
          request(options)
        end
      end

    end
  end
end

