module Fog
  module Compute
    class Cloudstack
      class Real

        def list_pods(options={})
          options.merge!(
            'command' => 'listPods'
          )
          
          request(options)
        end

      end
    end
  end
end
