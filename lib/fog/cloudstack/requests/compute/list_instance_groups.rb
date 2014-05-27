module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists vm groups
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listInstanceGroups.html]
        def list_instance_groups(options={})
          options.merge!(
            'command' => 'listInstanceGroups'  
          )
          request(options)
        end
      end

    end
  end
end

