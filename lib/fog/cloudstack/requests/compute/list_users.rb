module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists user accounts
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listUsers.html]
        def list_users(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listUsers') 
          else
            options.merge!('command' => 'listUsers')
          end
          request(options)
        end
      end

    end
  end
end

