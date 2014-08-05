module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a zones.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/dedicateZone.html]
        def dedicate_zone(domainid, zoneid, options={})
          options.merge!(
            'command' => 'dedicateZone', 
            'domainid' => domainid, 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

