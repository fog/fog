module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a Zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateZone.html]
        def update_zone(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateZone') 
          else
            options.merge!('command' => 'updateZone', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

