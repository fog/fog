module Fog
  module Compute
    class Cloudstack

      class Real
        # List the counters
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listCounters.html]
        def list_counters(options={})
          options.merge!(
            'command' => 'listCounters'  
          )
          request(options)
        end
      end

    end
  end
end

