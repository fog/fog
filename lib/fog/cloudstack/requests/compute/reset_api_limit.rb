module Fog
  module Compute
    class Cloudstack

      class Real
        # Reset api count
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/resetApiLimit.html]
        def reset_api_limit(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'resetApiLimit') 
          else
            options.merge!('command' => 'resetApiLimit')
          end
          request(options)
        end
      end

    end
  end
end

