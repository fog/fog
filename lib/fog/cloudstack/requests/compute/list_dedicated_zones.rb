module Fog
  module Compute
    class Cloudstack

      class Real
        # List dedicated zones.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listDedicatedZones.html]
        def list_dedicated_zones(options={})
          options.merge!(
            'command' => 'listDedicatedZones'  
          )
          request(options)
        end
      end

    end
  end
end

