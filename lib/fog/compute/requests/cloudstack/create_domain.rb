module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a domain.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/createDomain.html]
        def create_domain(options={})
          options.merge!(
            'command' => 'createDomain'
          )

          request(options)
        end

      end
    end
  end
end
