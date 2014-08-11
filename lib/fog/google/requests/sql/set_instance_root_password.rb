module Fog
  module Google
    class SQL
      ##
      # Sets the password for the root user
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/instances/setRootPassword

      class Real
        def set_instance_root_password(instance_id, password)
          api_method = @sql.instances.set_root_password
          parameters = {
            'project' => @project,
            'instance' => instance_id,
          }

          body = {
            'setRootPasswordContext' => {
              'kind' => 'sql#setRootUserContext',
              'password' => password,
            }
          }

          request(api_method, parameters, body)
        end
      end

      class Mock
        def set_instance_root_password(instance_id, password)
          operation = self.random_operation
          self.data[:operations][instance_id] ||= {}
          self.data[:operations][instance_id][operation] = {
            'kind' => 'sql#instanceOperation',
            'instance' => instance_id,
            'operation' => operation,
            'operationType' => 'INJECT_USER',
            'state' => Fog::Google::SQL::Operation::DONE_STATE,
            'userEmailAddress' => 'google_client_email@developer.gserviceaccount.com',
            'enqueuedTime' => Time.now.iso8601,
            'startTime' => Time.now.iso8601,
            'endTime' => Time.now.iso8601,
          }

          body = {
            'kind' => 'sql#instancesSetRootPassword',
            'operation' => operation,
          }

          build_excon_response(body)
        end
      end
    end
  end
end
