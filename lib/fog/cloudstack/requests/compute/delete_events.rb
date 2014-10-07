module Fog
  module Compute
    class Cloudstack

      class Real
        # Delete one or more events.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteEvents.html]
        def delete_events(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteEvents') 
          else
            options.merge!('command' => 'deleteEvents')
          end
          request(options)
        end
      end

    end
  end
end

