module Fog
  module Compute
    class Cloudstack

      class Real
        # Disables an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/disableAccount.html]
        def disable_account(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'disableAccount') 
          else
            options.merge!('command' => 'disableAccount', 
            'lock' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

