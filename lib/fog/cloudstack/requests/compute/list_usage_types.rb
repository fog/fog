module Fog
  module Compute
    class Cloudstack

      class Real
        # List Usage Types
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listUsageTypes.html]
        def list_usage_types(options={})
          options.merge!(
            'command' => 'listUsageTypes'  
          )
          request(options)
        end
      end

    end
  end
end

