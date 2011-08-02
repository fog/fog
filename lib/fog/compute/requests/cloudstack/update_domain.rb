module Fog
  module Compute
    class Cloudstack
      class Real

        # Updates a domain with a new name.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/updateDomain.html]
        def update_domain(options={})
          options.merge!(
            'command' => 'updateDomain'
          )

          request(options)
        end

      end
    end
  end
end
