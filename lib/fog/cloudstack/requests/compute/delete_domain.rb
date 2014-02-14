  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a specified domain
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteDomain.html]
          def delete_domain(options={})
            options.merge!(
              'command' => 'deleteDomain'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
