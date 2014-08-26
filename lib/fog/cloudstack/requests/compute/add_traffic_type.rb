module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds traffic type to a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addTrafficType.html]
        def add_traffic_type(options={})
          request(options)
        end


        def add_traffic_type(traffictype, physicalnetworkid, options={})
          options.merge!(
            'command' => 'addTrafficType', 
            'traffictype' => traffictype, 
            'physicalnetworkid' => physicalnetworkid  
          )
          request(options)
        end
      end

    end
  end
end

