module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a Zone.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/3.0.3/api_3.0.3/root_admin/createZone.html]
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
