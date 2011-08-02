module Fog
  module Compute
    class Cloudstack
      class Real

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
