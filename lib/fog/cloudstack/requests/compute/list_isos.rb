  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists all available ISO files.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listIsos.html]
          def list_isos(options={})
            options.merge!(
              'command' => 'listIsos'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
