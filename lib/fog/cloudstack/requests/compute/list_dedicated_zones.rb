module Fog
  module Compute
    class Cloudstack

      class Real
        # List dedicated zones.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listDedicatedZones.html]
        def list_dedicated_zones(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listDedicatedZones') 
          else
            options.merge!('command' => 'listDedicatedZones')
          end
          request(options)
        end
      end

    end
  end
end

