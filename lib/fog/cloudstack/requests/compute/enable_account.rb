module Fog
  module Compute
    class Cloudstack

      class Real
        # Enables an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/enableAccount.html]
        def enable_account(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'enableAccount') 
          else
            options.merge!('command' => 'enableAccount')
          end
          request(options)
        end
      end

    end
  end
end

