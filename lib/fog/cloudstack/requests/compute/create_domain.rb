  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a domain
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createDomain.html]
          def create_domain(options={})
            options.merge!(
              'command' => 'createDomain'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
