module Fog
  module Compute
    class Cloudstack

      class Real
        # Get API limit count for the caller
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/getApiLimit.html]
        def get_api_limit(options={})
          options.merge!(
            'command' => 'getApiLimit'  
          )
          request(options)
        end
      end

    end
  end
end

