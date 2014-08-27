module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes traffic type of a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteTrafficType.html]
        def delete_traffic_type(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteTrafficType') 
          else
            options.merge!('command' => 'deleteTrafficType', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

