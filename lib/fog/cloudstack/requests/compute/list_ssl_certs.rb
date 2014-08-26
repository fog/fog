module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists SSL certificates
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listSslCerts.html]
        def list_ssl_certs(options={})
          request(options)
        end


        def list_ssl_certs(options={})
          options.merge!(
            'command' => 'listSslCerts'  
          )
          request(options)
        end
      end

    end
  end
end

