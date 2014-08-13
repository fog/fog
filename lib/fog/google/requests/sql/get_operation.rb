module Fog
  module Google
    class SQL
      ##
      # Retrieves an instance operation that has been performed on an instance
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/operations/get

      class Real
        def get_operation(instance_id, operation_id)
          api_method = @sql.operations.get
          parameters = {
            'project' => @project,
            'instance' => instance_id,
            'operation' => operation_id,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def get_operation(instance_id, operation_id)
          if self.data[:operations].has_key?(instance_id)
            if self.data[:operations][instance_id].has_key?(operation_id)
              body = self.data[:operations][instance_id][operation_id]
              status = 200
            else
              body = {
                'error' => {
                  'errors' => [
                    {
                      'domain' => 'global',
                      'reason' => 'operationDoesNotExist',
                      'message' => 'The Cloud SQL instance operation does not exist.',
                    }
                  ],
                  'code' => 404,
                  'message' => 'The Cloud SQL instance operation does not exist.',
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
