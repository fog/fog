module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a snapshot for an account that already exists.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/createSnapshot.html]
        def create_snapshot(options={})
          options.merge!(
            'command' => 'createSnapshot'
          )

          request(options)
        end

      end
    end
  end
end
