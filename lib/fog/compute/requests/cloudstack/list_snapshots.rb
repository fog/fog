module Fog
  module Compute
    class Cloudstack
      class Real

        def list_snapshots(options={})
          options.merge!(
            'command' => 'listSnapshots'
          )
          
          request(options)
        end

      end
    end
  end
end
