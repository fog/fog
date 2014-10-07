module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists vm groups
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listInstanceGroups.html]
        def list_instance_groups(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listInstanceGroups') 
          else
            options.merge!('command' => 'listInstanceGroups')
          end
          request(options)
        end
      end

    end
  end
end

