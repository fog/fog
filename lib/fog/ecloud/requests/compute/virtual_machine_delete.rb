module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :virtual_machine_delete, 202, 'DELETE'
      end

      class Mock
        def virtual_machine_delete(uri)
          server_id = id_from_uri(uri)

          server  = self.data[:servers][server_id]
          task_id = Fog::Mock.random_numbers(10)
          task = {
            :id            => task_id,
            :href          => "/cloudapi/ecloud/tasks/#{task_id}",
            :type          => "application/vnd.tmrk.cloud.task",
            :Operation     => "Delete Server",
            :Status        => "Complete",
            :ImpactedItem  => Fog::Ecloud.keep(server, :name, :href, :type),
            :StartTime     => Time.now.iso8601,
            :CompletedTime => Time.now.iso8601,
            :InitiatedBy   => {},
          }
          self.data[:tasks][task_id] = task

          response(body: task)
        end
      end
    end
  end
end
