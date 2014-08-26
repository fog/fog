module Fog
  module Compute
    class Cloudstack

      class Real
        # Uploads a custom certificate for the console proxy VMs to use for SSL. Can be used to upload a single certificate signed by a known CA. Can also be used, through multiple calls, to upload a chain of certificates from CA to the custom certificate itself.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/uploadCustomCertificate.html]
        def upload_custom_certificate(domainsuffix, certificate, options={})
          options.merge!(
            'command' => 'uploadCustomCertificate', 
            'domainsuffix' => domainsuffix, 
            'certificate' => certificate  
          )
          request(options)
        end
      end

    end
  end
end

