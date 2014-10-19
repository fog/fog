module Fog
  module Compute
    class Cloudstack

      class Real
        # List the counters
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listCounters.html]
        def list_counters(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listCounters') 
          else
            options.merge!('command' => 'listCounters')
          end
          request(options)
        end
      end

    end
  end
end

