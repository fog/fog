module Fog
  module Compute
    class Cloudstack
      class Real

        def list_volumes(options={})
          options.merge!(
            'command' => 'listVolumes'
          )
          
          request(options)
        end

      end
    end
  end
end
