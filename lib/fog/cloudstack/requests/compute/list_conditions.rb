module Fog
  module Compute
    class Cloudstack

      class Real
        # List Conditions for the specific user
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listConditions.html]
        def list_conditions(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listConditions') 
          else
            options.merge!('command' => 'listConditions')
          end
          request(options)
        end
      end

    end
  end
end

