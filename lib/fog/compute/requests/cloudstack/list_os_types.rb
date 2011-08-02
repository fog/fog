module Fog
  module Compute
    class Cloudstack
      class Real

        def list_os_types(options={})
          options.merge!(
            'command' => 'listOsTypes'
          )
          
          request(options)
        end

      end
    end
  end
end


