module Fog
  module Google
    class SQL
      ##
      # Lists all instance operations that have been performed on the given Cloud SQL instance
      # in the reverse chronological order of the start time
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/operations/list

      class Real
        def list_operations(instance_id)
          api_method = @sql.operations.list
          parameters = {
            'project' => @project,
            'instance' => instance_id,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def list_operations(instance_id)
          if self.data[:operations].has_key?(instance_id)
            body = {
              'kind' => 'sql#operationsList',
              'items' => self.data[:operations][instance_id].values,
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
