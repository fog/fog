module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a zones.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/dedicateZone.html]
        def dedicate_zone(options={})
          options.merge!(
            'command' => 'dedicateZone',
            'zoneid' => options['zoneid'], 
            'domainid' => options['domainid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

