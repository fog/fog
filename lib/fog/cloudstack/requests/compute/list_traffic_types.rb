module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists traffic types of a given physical network.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listTrafficTypes.html]
        def list_traffic_types(physicalnetworkid, options={})
          options.merge!(
            'command' => 'listTrafficTypes', 
            'physicalnetworkid' => physicalnetworkid  
          )
          request(options)
        end
      end

    end
  end
end

