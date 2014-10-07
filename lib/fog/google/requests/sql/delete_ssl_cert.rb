module Fog
  module Google
    class SQL
      ##
      # Deletes a SSL certificate. The change will not take effect until the instance is restarted.
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/sslCerts/delete

      class Real
        def delete_ssl_cert(instance_id, sha1_fingerprint)
          api_method = @sql.ssl_certs.delete
          parameters = {
            'project' => @project,
            'instance' => instance_id,
            'sha1Fingerprint' => sha1_fingerprint,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def delete_ssl_cert(instance_id, sha1_fingerprint)
          if self.data[:ssl_certs].has_key?(instance_id)
            self.data[:ssl_certs][instance_id].delete(sha1_fingerprint)

            operation = self.random_operation
            self.data[:operations][instance_id] ||= {}
            self.data[:operations][instance_id][operation] = {
              'kind' => 'sql#instanceOperation',
              'instance' => instance_id,
              'operation' => operation,
              'operationType' => 'UPDATE',
              'state' => Fog::Google::SQL::Operation::DONE_STATE,
              'userEmailAddress' => 'google_client_email@developer.gserviceaccount.com',
              'enqueuedTime' => Time.now.iso8601,
              'startTime' => Time.now.iso8601,
              'endTime' => Time.now.iso8601,
            }

            body = {
              'kind' => 'sql#sslCertsDelete',
              'operation' => operation,
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
