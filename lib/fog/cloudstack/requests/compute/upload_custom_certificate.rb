module Fog
  module Compute
    class Cloudstack

      class Real
        # Uploads a custom certificate for the console proxy VMs to use for SSL. Can be used to upload a single certificate signed by a known CA. Can also be used, through multiple calls, to upload a chain of certificates from CA to the custom certificate itself.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/uploadCustomCertificate.html]
        def upload_custom_certificate(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'uploadCustomCertificate') 
          else
            options.merge!('command' => 'uploadCustomCertificate', 
            'domainsuffix' => args[0], 
            'certificate' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

