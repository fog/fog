module Fog
  module Compute
    class Cloudstack
      class Real

        # A command to list events.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listEvents.html]
        def list_events(options={})
          options.merge!(
            'command' => 'listEvents'
          )
          
          request(options)
        end

      end
    end
  end
end
