require 'fog/vcloud/models/compute/task'

module Fog
  module Vcloud
    class Compute

      class Tasks < Fog::Vcloud::Collection

        model Fog::Vcloud::Compute::Task

        attribute :href, :aliases => :Href

        def all
          self.href = connection.default_vdc_href unless self.href
          check_href!
          if data = connection.get_task_list(href).body[:Task]
            load(data)
          end
        end

        def get(uri)
          if data = connection.get_task(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
