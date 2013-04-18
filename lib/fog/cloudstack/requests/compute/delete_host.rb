module Fog
  module Compute
    class Cloudstack
      class Real

        # Deletes a host.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/3.0.3/api_3.0.3/root_admin/deleteHost.html]
        def delete_host(options={})
          options.merge!(
            'command' => 'deleteHost'
          )
          request(options)
        end

      end # Real
    end # Cloudstack
  end # Compute
end # Fog
