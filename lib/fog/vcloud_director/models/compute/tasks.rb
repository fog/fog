require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/task'

module Fog
  module Compute
    class VcloudDirector

      class Tasks < Collection
        model Fog::Compute::VcloudDirector::Task

        attribute :organization

        def get(id)
          data = service.get_task(id).body
          return nil unless data
          data[:id] = data[:href].split('/').last
          new(data)
        end

        private

        def item_list
          data = service.get_task_list(organization.id).body
          data[:Task].each {|task| service.add_id_from_href!(task)}
        end

      end
    end
  end
end
