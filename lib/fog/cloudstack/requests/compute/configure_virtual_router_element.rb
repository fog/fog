module Fog
  module Compute
    class Cloudstack
      class Real

        # Configures a virtual router element.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/3.0.3/api_3.0.3/root_admin/configureVirtualRouterElement.html]
        def configure_virtual_router_element(options={})
          options.merge!(
            'command' => 'configureVirtualRouterElement'
          )
          request(options)
        end

      end # Real
    end # Cloudstack
  end # Compute
end # Fog
