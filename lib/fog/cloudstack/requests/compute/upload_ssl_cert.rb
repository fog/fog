module Fog
  module Compute
    class Cloudstack

      class Real
        # Upload a certificate to cloudstack
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/uploadSslCert.html]
        def upload_ssl_cert(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'uploadSslCert') 
          else
            options.merge!('command' => 'uploadSslCert', 
            'certificate' => args[0], 
            'privatekey' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

