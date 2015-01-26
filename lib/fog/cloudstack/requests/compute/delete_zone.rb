module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteZone.html]
        def delete_zone(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteZone') 
          else
            options.merge!('command' => 'deleteZone', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

