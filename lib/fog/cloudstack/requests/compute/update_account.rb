module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates account information for the authenticated user
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateAccount.html]
        def update_account(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateAccount') 
          else
            options.merge!('command' => 'updateAccount', 
            'newname' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

