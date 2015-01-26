module Fog
  module Compute
    class Cloudstack

      class Real
        # A command to list events.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listEvents.html]
        def list_events(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listEvents') 
          else
            options.merge!('command' => 'listEvents')
          end
          request(options)
        end
      end

    end
  end
end

