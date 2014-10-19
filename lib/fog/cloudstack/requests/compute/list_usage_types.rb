module Fog
  module Compute
    class Cloudstack

      class Real
        # List Usage Types
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listUsageTypes.html]
        def list_usage_types(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listUsageTypes') 
          else
            options.merge!('command' => 'listUsageTypes')
          end
          request(options)
        end
      end

    end
  end
end

