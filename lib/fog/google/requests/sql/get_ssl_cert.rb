module Fog
  module Google
    class SQL
      ##
      # Retrieves a particular SSL certificate (does not include the private key)
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/sslCerts/get

      class Real
        def get_ssl_cert(instance_id, sha1_fingerprint)
          api_method = @sql.ssl_certs.get
          parameters = {
            'project' => @project,
            'instance' => instance_id,
            'sha1Fingerprint' => sha1_fingerprint,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def get_ssl_cert(instance_id, sha1_fingerprint)
          if self.data[:ssl_certs].has_key?(instance_id)
            if self.data[:ssl_certs][instance_id].has_key?(sha1_fingerprint)
              body = self.data[:ssl_certs][instance_id][sha1_fingerprint]
              status = 200
            else
              body = {
                'error' => {
                  'errors' => [
                    {
                      'domain' => 'global',
                      'reason' => 'sslCertificateDoesNotExist',
                      'message' => 'The SSL certificate does not exist.',
                    }
                  ],
                  'code' => 404,
                  'message' => 'The SSL certificate does not exist.',
                }
              }
              status = 404
            end
          else
            body = {
              'error' => {
                'errors' => [
                  {
                    'domain' => 'global',
                    'reason' => 'notAuthorized',
                    'message' => 'The client is not authorized to make this request.',
                  }
                ],
                'code' => 403,
                'message' => 'The client is not authorized to make this request.',
             }
            }
            status = 403
          end

          build_excon_response(body, status)
        end
      end
    end
  end
end
