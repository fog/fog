module Fog
  module Google
    class SQL
      ##
      # Lists instances under a given project in the alphabetical order of the instance name
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/instances/list

      class Real
        def list_instances
          api_method = @sql.instances.list
          parameters = {
            'project' => @project,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def list_instances
          body = {
            'kind' => 'sql#instancesList',
            'items' => self.data[:instances].values,
          }

          build_excon_response(body)
        end
      end
    end
  end
end
