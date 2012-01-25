module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists zones.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listZones.html]
        def list_zones(options={})
          options.merge!(
            'command' => 'listZones'
          )

          request(options)
        end

      end
    end
  end
end
