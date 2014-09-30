module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists SSL certificates
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listSslCerts.html]
        def list_ssl_certs(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listSslCerts') 
          else
            options.merge!('command' => 'listSslCerts')
          end
          request(options)
        end
      end

    end
  end
end

