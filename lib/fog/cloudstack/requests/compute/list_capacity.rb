module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all the system wide capacities.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listCapacity.html]
        def list_capacity(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listCapacity') 
          else
            options.merge!('command' => 'listCapacity')
          end
          request(options)
        end
      end

    end
  end
end

