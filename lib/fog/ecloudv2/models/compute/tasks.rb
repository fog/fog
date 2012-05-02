require 'fog/ecloudv2/models/compute/task'

module Fog
  module Compute
    class Ecloudv2
      class Tasks < Fog::Ecloudv2::Collection
        
        model Fog::Compute::Ecloudv2::Task

        identity :href
        attribute :other_links, :aliases => :Links
        attribute :total_count, :aliases => :TotalCount

        def all
          data = connection.get_tasks(href).body[:Task]
          load(data)
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

