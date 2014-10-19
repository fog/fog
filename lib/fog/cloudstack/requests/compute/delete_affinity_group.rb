module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes affinity group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteAffinityGroup.html]
        def delete_affinity_group(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteAffinityGroup') 
          else
            options.merge!('command' => 'deleteAffinityGroup')
          end
          request(options)
        end
      end

    end
  end
end

