  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Extracts volume
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/extractVolume.html]
          def extract_volume(options={})
            options.merge!(
              'command' => 'extractVolume'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
