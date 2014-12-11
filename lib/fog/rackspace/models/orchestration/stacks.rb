require 'fog/rackspace/models/orchestration/stack'

module Fog
  module Rackspace
    class Orchestration
      class Stacks < Fog::Collection
        model Fog::Rackspace::Orchestration::Stack

        def all(options={})
          data = service.list_stack_data(options).body['stacks']
          load(data)
        end

        def get(name, id)
          data = service.show_stack_details(name, id).body['stack']
          new(data)
        rescue Fog::Rackspace::Orchestration::NotFound
          nil
        end

        def adopt(options={})
          service.create_stack(options)
        end

        def create(options={})
          service.create_stack(options).body['stack']
        end

        def preview(options={})
          data = service.preview_stack(options).body['stack']
          new(data)
        end

        def build_info
          service.build_info.body
        end
      end
    end
  end
end
