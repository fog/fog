module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a volume for an account that already exists.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/createVolume.html]
        def create_volume(options={})
          options.merge!(
            'command' => 'createVolume'
          )

          request(options)
        end

      end
    end
  end
end
