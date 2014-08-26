module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists user accounts
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listUsers.html]
        def list_users(options={})
          options.merge!(
            'command' => 'listUsers'  
          )
          request(options)
        end
      end

    end
  end
end

