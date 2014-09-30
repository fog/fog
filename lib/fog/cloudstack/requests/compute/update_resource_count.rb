module Fog
  module Compute
    class Cloudstack

      class Real
        # Recalculate and update resource count for an account or domain.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateResourceCount.html]
        def update_resource_count(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateResourceCount') 
          else
            options.merge!('command' => 'updateResourceCount', 
            'domainid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

