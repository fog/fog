module Fog
  module Compute
    class Cloudstack

      class Real
        # Find user account by API key
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/getUser.html]
        def get_user(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'getUser') 
          else
            options.merge!('command' => 'getUser', 
            'apikey' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

