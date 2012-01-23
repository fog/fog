module Fog
  module Compute
    class Cloudstack
      class Real

        # Deletes a specified user.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/deleteVolume.html]
        def delete_volume(options={})
          options.merge!(
            'command' => 'deleteVolume'
          )

          request(options)
        end

      end
    end
  end
end
