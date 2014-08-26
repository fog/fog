module Fog
  module Compute
    class Cloudstack

      class Real
        # Delete a certificate to cloudstack
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteSslCert.html]
        def delete_ssl_cert(options={})
          request(options)
        end


        def delete_ssl_cert(id, options={})
          options.merge!(
            'command' => 'deleteSslCert', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

