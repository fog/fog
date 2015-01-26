module Fog
  module Rackspace
    class Orchestration
      class Stack < Fog::Model

        identity :id

        %w{description links stack_status_reason stack_name creation_time updated_time}.each do |a|
          attribute a.to_sym
        end

        def details
          service.show_stack_details(self.stack_name, self.id).body['stack']
        rescue Fog::Rackspace::Orchestration::NotFound
          nil
        end

        def resources
          @resources ||= service.resources.all(self)
        end

        def events(options={})
          @events ||= service.events.all(self, options)
        end

        def template
          @template ||= service.templates.get(self)
        end

        def save(options={})
          if persisted?
            service.update_stack(self, options).body['stack']
          else
            service.stacks.create(options)
          end
        end

        def abandon
          service.abandon_stack(self)
        end

        def delete
          service.delete_stack(self)
        end
      end
    end
  end
end
