module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a user account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateUser.html]
        def update_user(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateUser') 
          else
            options.merge!('command' => 'updateUser', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

