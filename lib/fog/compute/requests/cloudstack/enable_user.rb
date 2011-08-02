module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a user for an account that already exists
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/disableUser.html]
        def enable_user(options={})
          options.merge!(
            'command' => 'enableUser'
          )

          request(options)
        end

      end
    end
  end
end
