module Fog
  module Google
    class SQL
      ##
      # Lists all of the current SSL certificates for the instance
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/sslCerts/list

      class Real
        def list_ssl_certs(instance_id)
          api_method = @sql.ssl_certs.list
          parameters = {
            'project' => @project,
            'instance' => instance_id,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def list_ssl_certs(instance_id)
          if self.data[:ssl_certs].has_key?(instance_id)
            body = {
              'kind' => 'sql#sslCertsList',
              'items' => self.data[:ssl_certs][instance_id].values,
            }
            status = 200
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
