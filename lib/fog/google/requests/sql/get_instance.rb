module Fog
  module Google
    class SQL
      ##
      # Retrieves a resource containing information about a Cloud SQL instance
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/instances/get

      class Real
        def get_instance(instance_id)
          api_method = @sql.instances.get
          parameters = {
            'project' => @project,
            'instance' => instance_id,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def get_instance(instance_id)
          if self.data[:instances].has_key?(instance_id)
            body = self.data[:instances][instance_id]
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
