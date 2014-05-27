module Fog
  module Compute
    class Cloudstack

      class Real
        # A command to list events.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listEvents.html]
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

