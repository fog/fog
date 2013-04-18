module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a Zone.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/3.0.3/api_3.0.3/root_admin/listSystemVms.html]
        def list_system_vms(options={})
          options.merge!(
            'command' => 'listSystemVms'
          )
          request(options)
        end

      end # Real
    end # Cloudstack
  end # Compute
end # Fog
