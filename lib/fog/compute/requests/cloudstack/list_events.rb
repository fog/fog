module Fog
  module Compute
    class Cloudstack
      class Real

        def list_events(options={})
          options.merge!(
            'command' => 'listEvents'
          )
          
          request(options)
        end

      end
    end
  end
end
