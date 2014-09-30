module Fog
  module Google
    class SQL
      ##
      # Deletes a Cloud SQL instance
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/instances/delete

      class Real
        def delete_instance(instance_id)
          api_method = @sql.instances.delete
          parameters = {
            'project' => @project,
            'instance' => instance_id,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def delete_instance(instance_id)
          if self.data[:instances].has_key?(instance_id)
            self.data[:instances].delete(instance_id)
            self.data[:ssl_certs].delete(instance_id)
            self.data[:backup_runs].delete(instance_id)

            operation = self.random_operation
            self.data[:operations][instance_id] ||= {}
            self.data[:operations][instance_id][operation] = {
              'kind' => 'sql#instanceOperation',
              'instance' => instance_id,
              'operation' => operation,
              'operationType' => 'DELETE',
              'state' => Fog::Google::SQL::Operation::PENDING_STATE,
              'userEmailAddress' => 'google_client_email@developer.gserviceaccount.com',
              'enqueuedTime' => Time.now.iso8601,
            }

            body = {
              'kind' => 'sql#instancesDelete',
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
