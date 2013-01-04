module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :internet_service_delete, 202, 'DELETE'
      end

      class Mock
        def internet_service_delete(uri)
          service_id = id_from_uri(uri)

          service = self.data[:internet_services][service_id].dup
          self.data[:internet_services].delete(service_id)

          task_id = Fog::Mock.random_numbers(10).to_i
          task = {
            :id            => task_id,
            :href          => "/cloudapi/ecloud/tasks/#{task_id}",
            :type          => "application/vnd.tmrk.cloud.task",
            :Operation     => "Delete Service",
            :Status        => "Complete",
            :ImpactedItem  => Fog::Ecloud.keep(service, :name, :href, :type),
            :StartTime     => Time.now.iso8601,
            :CompletedTime => Time.now.iso8601,
            :InitiatedBy   => {},
          }
          self.data[:tasks][task_id] = task
          response(:body => task)
        end
      end
    end
  end
end
