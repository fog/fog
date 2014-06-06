module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates traffic type of a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateTrafficType.html]
        def update_traffic_type(id, options={})
          options.merge!(
            'command' => 'updateTrafficType', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

