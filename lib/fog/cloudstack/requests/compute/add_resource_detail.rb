module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds detail for the Resource.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addResourceDetail.html]
        def add_resource_detail(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addResourceDetail') 
          else
            options.merge!('command' => 'addResourceDetail', 
            'resourcetype' => args[0], 
            'details' => args[1], 
            'resourceid' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

