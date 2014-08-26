module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a Pod.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/dedicatePod.html]
        def dedicate_pod(options={})
          request(options)
        end


        def dedicate_pod(podid, domainid, options={})
          options.merge!(
            'command' => 'dedicatePod', 
            'podid' => podid, 
            'domainid' => domainid  
          )
          request(options)
        end
      end

    end
  end
end

