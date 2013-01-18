module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists zones.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listZones.html]
        def create_zone(options={})
          options.merge!(
            'command' => 'createZone'
          )

          request(options)
        end

      end # Real
    end # Cloudstack
  end # Compute
end # Fog
