module Fog
  module Compute
    class Cloudstack
      class Real

        def list_external_firewalls(options={})
          options.merge!(
            'command' => 'listExternalFirewalls'
          )
          
          request(options)
        end

      end
    end
  end
end
