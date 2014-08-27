module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an affinity/anti-affinity group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createAffinityGroup.html]
        def create_affinity_group(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createAffinityGroup') 
          else
            options.merge!('command' => 'createAffinityGroup', 
            'type' => args[0], 
            'name' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

