module Fog
  module Compute
    class Cloudstack

      class Real
        # Release dedication of zone
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/releaseDedicatedZone.html]
        def release_dedicated_zone(options={})
          options.merge!(
            'command' => 'releaseDedicatedZone', 
            'zoneid' => options['zoneid']  
          )
          request(options)
        end
      end

    end
  end
end

