module Fog
  module Compute
    class Cloudstack

      class Real
        # Find user account by API key
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/getUser.html]
        def get_user(options={})
          request(options)
        end


        def get_user(apikey, options={})
          options.merge!(
            'command' => 'getUser', 
            'apikey' => apikey  
          )
          request(options)
        end
      end

    end
  end
end

