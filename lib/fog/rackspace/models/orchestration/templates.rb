require 'fog/rackspace/models/orchestration/template'

module Fog
  module Rackspace
    class Orchestration
      class Templates < Fog::Collection
        model Fog::Rackspace::Orchestration::Template

        def get(obj)
          data = if obj.is_a?(Stack)
            service.get_stack_template(obj).body
          else
            service.show_resource_template(obj.resource_name).body
          end

          new(data)
        rescue Fog::Rackspace::Orchestration::NotFound
          nil
        end

        def validate(options={})
          data = service.validate_template(options).body
          temp = new
          temp.parameters  = data['Parameters']
          temp.description = data['Description']
          temp
        end
      end
    end
  end
end
