module Fog
  module Compute
    class Cloudstack
      class Real

        # Updates a user account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/updateResourceCount.html]
        def update_resource_count(options={})
          options.merge!(
            'command' => 'updateResourceCount'
          )

          request(options)
        end

      end
    end
  end
end
