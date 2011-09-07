module Fog
  module Compute
    class Cloudstack
      class Real

        # Deletes a specified user.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/deleteSnapshot.html]
        def delete_snapshot(options={})
          options.merge!(
            'command' => 'deleteSnapshot'
          )

          request(options)
        end

      end
    end
  end
end
