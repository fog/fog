module Fog
  module Compute
    class Cloudstack

      class Real
        # Get API limit count for the caller
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/getApiLimit.html]
        def get_api_limit(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'getApiLimit') 
          else
            options.merge!('command' => 'getApiLimit')
          end
          request(options)
        end
      end

    end
  end
end

