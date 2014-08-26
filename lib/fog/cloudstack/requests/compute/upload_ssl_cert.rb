module Fog
  module Compute
    class Cloudstack

      class Real
        # Upload a certificate to cloudstack
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/uploadSslCert.html]
        def upload_ssl_cert(options={})
          request(options)
        end


        def upload_ssl_cert(certificate, privatekey, options={})
          options.merge!(
            'command' => 'uploadSslCert', 
            'certificate' => certificate, 
            'privatekey' => privatekey  
          )
          request(options)
        end
      end

    end
  end
end

