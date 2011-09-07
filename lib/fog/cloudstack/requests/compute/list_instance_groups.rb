module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists VM groups.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listInstanceGroups.html]
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
