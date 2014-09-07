module Fog
  module Compute
    class Cloudstack

      class Real
        # Release dedication of zone
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/releaseDedicatedZone.html]
        def release_dedicated_zone(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'releaseDedicatedZone') 
          else
            options.merge!('command' => 'releaseDedicatedZone', 
            'zoneid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

