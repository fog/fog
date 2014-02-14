  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Uploads a data disk.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/uploadVolume.html]
          def upload_volume(options={})
            options.merge!(
              'command' => 'uploadVolume'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
