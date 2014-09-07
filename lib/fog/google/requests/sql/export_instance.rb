module Fog
  module Google
    class SQL
      ##
      # Exports data from a Cloud SQL instance to a Google Cloud Storage bucket as a MySQL dump file
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/instances/export

      class Real
        def export_instance(instance_id, uri, options = {})
          api_method = @sql.instances.export
          parameters = {
            'project' => @project,
            'instance' => instance_id,
          }

          body = {
            'exportContext' => {
              'kind' => 'sql#exportContext',
              'uri' => uri,
              'database' => Array(options[:databases]),
              'table' => Array(options[:tables]),
            }
          }

          request(api_method, parameters, body)
        end
      end

      class Mock
        def export_instance(instance_id, uri, options = {})
          operation = self.random_operation
          self.data[:operations][instance_id] ||= {}
          self.data[:operations][instance_id][operation] = {
            'kind' => 'sql#instanceOperation',
            'instance' => instance_id,
            'operation' => operation,
            'operationType' => 'EXPORT',
            'state' => Fog::Google::SQL::Operation::DONE_STATE,
            'userEmailAddress' => 'google_client_email@developer.gserviceaccount.com',
            'enqueuedTime' => Time.now.iso8601,
            'startTime' => Time.now.iso8601,
            'endTime' => Time.now.iso8601,
          }

          body = {
            'kind' => 'sql#instancesExport',
            'operation' => operation,
          }

          build_excon_response(body)
        end
      end
    end
  end
end
