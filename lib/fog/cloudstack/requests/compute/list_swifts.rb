module Fog
  module Compute
    class Cloudstack

      class Real
        # List Swift.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listSwifts.html]
        def list_swifts(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listSwifts') 
          else
            options.merge!('command' => 'listSwifts')
          end
          request(options)
        end
      end

    end
  end
end

