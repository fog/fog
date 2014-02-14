  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Uploads custom certificate
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/uploadCustomCertificate.html]
          def upload_custom_certificate(options={})
            options.merge!(
              'command' => 'uploadCustomCertificate'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
