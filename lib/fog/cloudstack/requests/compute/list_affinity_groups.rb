module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists affinity groups
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listAffinityGroups.html]
        def list_affinity_groups(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listAffinityGroups') 
          else
            options.merge!('command' => 'listAffinityGroups')
          end
          request(options)
        end
      end

    end
  end
end

