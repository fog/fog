module Fog
  module Compute
    class Cloudstack

      class Real
        # Archive one or more events.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/archiveEvents.html]
        def archive_events(options={})
          options.merge!(
            'command' => 'archiveEvents'  
          )
          request(options)
        end
      end

    end
  end
end

