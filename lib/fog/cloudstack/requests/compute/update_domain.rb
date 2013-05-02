  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a domain with a new name
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateDomain.html]
          def update_domain(options={})
            options.merge!(
              'command' => 'updateDomain'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
