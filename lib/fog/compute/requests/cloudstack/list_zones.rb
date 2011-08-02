module Fog
  module Compute
    class Cloudstack
      class Real

        def list_zones(options={})
          options.merge!(
            'command' => 'listZones'
          )
          
          request(options)
        end

      end
    end
  end
end
