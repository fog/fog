module Fog
  module Compute
    class Cloudstack

      class Real
        # List Event Types
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listEventTypes.html]
        def list_event_types(options={})
          options.merge!(
            'command' => 'listEventTypes'  
          )
          request(options)
        end
      end

    end
  end
end

