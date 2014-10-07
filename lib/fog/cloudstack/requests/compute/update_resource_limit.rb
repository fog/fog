module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates resource limits for an account or domain.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateResourceLimit.html]
        def update_resource_limit(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateResourceLimit') 
          else
            options.merge!('command' => 'updateResourceLimit', 
            'resourcetype' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

