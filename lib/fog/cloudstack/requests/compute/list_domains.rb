  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists domains and provides detailed information for listed domains
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listDomains.html]
          def list_domains(options={})
            options.merge!(
              'command' => 'listDomains'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
