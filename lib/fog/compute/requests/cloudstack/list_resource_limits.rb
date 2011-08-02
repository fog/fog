module Fog
  module Compute
    class Cloudstack
      class Real

        def list_resource_limits(options={})
          options.merge!(
            'command' => 'listResourceLimits'
          )
          
          request(options)
        end

      end
    end
  end
end
