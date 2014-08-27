module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists traffic types of a given physical network.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listTrafficTypes.html]
        def list_traffic_types(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listTrafficTypes') 
          else
            options.merge!('command' => 'listTrafficTypes', 
            'physicalnetworkid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

