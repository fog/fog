module Fog
  module Compute
    class Cloudstack

      class Real
        # Delete one or more events.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteEvents.html]
        def delete_events(options={})
          options.merge!(
            'command' => 'deleteEvents'  
          )
          request(options)
        end
      end

    end
  end
end

