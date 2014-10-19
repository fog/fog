module Fog
  module Compute
    class Cloudstack

      class Real
        # Archive one or more events.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/archiveEvents.html]
        def archive_events(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'archiveEvents') 
          else
            options.merge!('command' => 'archiveEvents')
          end
          request(options)
        end
      end

    end
  end
end

