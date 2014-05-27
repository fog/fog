module Fog
  module Compute
    class Cloudstack

      class Real
        # Reset api count
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/resetApiLimit.html]
        def reset_api_limit(options={})
          options.merge!(
            'command' => 'resetApiLimit'  
          )
          request(options)
        end
      end

    end
  end
end

