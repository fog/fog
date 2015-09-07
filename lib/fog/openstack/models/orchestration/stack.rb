require 'fog/openstack/models/model'

module Fog
  module Orchestration
    class OpenStack
      class Stack < Fog::OpenStack::Model

        identity :id

        %w{capabilities description disable_rollback links notification_topics outputs parameters
            stack_name stack_status stack_status_reason template_description timeout_mins parent
            creation_time updated_time stack_user_project_id stack_owner}.each do |a|
          attribute a.to_sym
        end

        def save(options={})
          if persisted?
            service.update_stack(self, default_options.merge(options)).body['stack']
          else
            service.stacks.create(default_options.merge(options))
          end
        end

        # Deprecated
        def create
          Fog::Logger.deprecation("#create is deprecated, use #save(options) instead [light_black](#{caller.first})[/]")
          requires :stack_name
          service.stacks.create(default_options)
        end

        # Deprecated
        def update
          Fog::Logger.deprecation("#update is deprecated, use #save(options) instead [light_black](#{caller.first})[/]")
          requires :stack_name
          service.update_stack(self, default_options).body['stack']
        end

        def patch(options = {})
          requires :stack_name
          service.patch_stack(self, options).body['stack']
        end

        def delete
          service.delete_stack(self)
        end
        alias_method :destroy, :delete

        def details
          @details ||= service.stacks.get(self.stack_name, self.id)
        end

        def resources(options={})
          @resources ||= service.resources.all({:stack => self}.merge(options))
        end

        def events(options={})
          @events ||= service.events.all(self, options)
        end

        def template
          @template ||= service.templates.get(self)
        end

        def abandon
          service.abandon_stack(self)
        end


        # Deprecated
        def template_url
          Fog::Logger.deprecation("#template_url is deprecated, use it in options for #save(options) instead [light_black](#{caller.first})[/]")
          @template_url
        end

        # Deprecated
        def template_url=(url)
          Fog::Logger.deprecation("#template_url= is deprecated, use it in options for #save(options) instead [light_black](#{caller.first})[/]")
          @template_url = url
        end

        # Deprecated
        def template=(content)
          Fog::Logger.deprecation("#template=(content) is deprecated, use it in options for #save(options) instead [light_black](#{caller.first})[/]")
          @template = content
        end

        # Deprecated
        def timeout_in_minutes
          Fog::Logger.deprecation("#timeout_in_minutes is deprecated, set timeout_mins in options for save(options) instead [light_black](#{caller.first})[/]")
          timeout_mins
        end

        # Deprecated
        def timeout_in_minutes=(minutes)
          Fog::Logger.deprecation("#timeout_in_minutes=(minutes) is deprecated, set timeout_mins in options for save(options) instead [light_black](#{caller.first})[/]")
          timeout_mins = minutes
        end

        # build options to create or update stack
        def default_options
          template_content =
            if template && template.is_a?(Fog::Orchestration::OpenStack::Template)
              template.content
            else
              template
            end

          {
            :stack_name       => stack_name,
            :disable_rollback => disable_rollback,
            :template_url     => @template_url,
            :template         => template_content,
            :timeout_mins     => timeout_mins
          }
        end
        private :default_options
      end
    end
  end
end
