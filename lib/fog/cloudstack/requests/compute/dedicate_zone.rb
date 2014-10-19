module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a zones.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/dedicateZone.html]
        def dedicate_zone(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'dedicateZone') 
          else
            options.merge!('command' => 'dedicateZone', 
            'domainid' => args[0], 
            'zoneid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

