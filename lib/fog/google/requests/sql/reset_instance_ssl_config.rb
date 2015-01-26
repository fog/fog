module Fog
  module Google
    class SQL
      ##
      # Deletes all client certificates and generates a new server SSL certificate for the instance.
      # The changes will not take effect until the instance is restarted. Existing instances without
      # a server certificate will need to call this once to set a server certificate
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/instances/resetSslConfig

      class Real
        def reset_instance_ssl_config(instance_id)
          api_method = @sql.instances.reset_ssl_config
          parameters = {
            'project' => @project,
            'instance' => instance_id,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def reset_instance_ssl_config(instance_id)
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
            'kind' => 'sql#instancesResetSslConfig',
            'operation' => operation,
          }

          build_excon_response(body)
        end
      end
    end
  end
end
