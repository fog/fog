module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes traffic type of a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteTrafficType.html]
        def delete_traffic_type(options={})
          options.merge!(
            'command' => 'deleteTrafficType',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

