module Fog
  module Compute
    class Cloudstack

      class Real
        # List Event Types
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listEventTypes.html]
        def list_event_types(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listEventTypes') 
          else
            options.merge!('command' => 'listEventTypes')
          end
          request(options)
        end
      end

    end
  end
end

