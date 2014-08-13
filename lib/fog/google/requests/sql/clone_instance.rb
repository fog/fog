module Fog
  module Google
    class SQL
      ##
      # Creates a Cloud SQL instance as a clone of the source instance
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/instances/clone

      class Real
        def clone_instance(instance_id, destination_name, options = {})
          # The @sql.instances.clone method is overrided by the standard Ruby clone method
          # so we cannot call it because it will just clone the @sql.instances instance.
          # Instead we need to find the proper method trough the discovered_methods.
          api_method = @sql.instances.discovered_methods.find { |x| x.id == 'sql.instances.clone' }
          parameters = {
            'project' => @project,
          }

          body = {
            'cloneContext' => {
              'kind' => 'sql#cloneContext',
              'sourceInstanceName' => instance_id,
              'destinationInstanceName' => destination_name,
            }
          }

          if options[:log_position]
            body['cloneContext']['binLogCoordinates'] = {
              'kind' => 'sql#binLogCoordinates',
              'binLogFileName' => options[:log_filename],
              'binLogPosition' => options[:log_position],
            }
          end

          request(api_method, parameters, body)
        end
      end

      class Mock
        def clone_instance(instance_id, destination_name, options = {})
          self.data[:instances][destination_name] = self.data[:instances][instance_id]
          self.data[:instances][destination_name]['instance'] = destination_name
          self.data[:ssl_certs][destination_name] = {}
          self.data[:backup_runs][destination_name] = {}

          operation = self.random_operation
          self.data[:operations][destination_name] ||= {}
          self.data[:operations][destination_name][operation] = {
            'kind' => 'sql#instanceOperation',
            'instance' => destination_name,
            'operation' => operation,
            'operationType' => 'CREATE',
            'state' => Fog::Google::SQL::Operation::DONE_STATE,
            'userEmailAddress' => 'google_client_email@developer.gserviceaccount.com',
            'enqueuedTime' => Time.now.iso8601,
            'startTime' => Time.now.iso8601,
            'endTime' => Time.now.iso8601,
          }

          operation = self.random_operation
          self.data[:operations][instance_id] ||= {}
          self.data[:operations][instance_id][operation] = {
            'kind' => 'sql#instanceOperation',
            'instance' => instance_id,
            'operation' => operation,
            'operationType' => 'CLONE',
            'state' => Fog::Google::SQL::Operation::DONE_STATE,
            'userEmailAddress' => 'google_client_email@developer.gserviceaccount.com',
            'enqueuedTime' => Time.now.iso8601,
            'startTime' => Time.now.iso8601,
            'endTime' => Time.now.iso8601,
          }

          body = {
            'kind' => 'sql#instancesClone',
            'operation' => operation,
          }

          build_excon_response(body)
        end
      end
    end
  end
end
