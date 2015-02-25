require 'fog/openstack/models/orchestration/stack'

module Fog
  module Orchestration
    class OpenStack
      class Stacks < Fog::Collection
        model Fog::Orchestration::OpenStack::Stack

        def all(options={})
          data = service.list_stack_data(options).body['stacks']
          load(data)
        end

        # Deprecated
        def find_by_id(id)
          Fog::Logger.deprecation("#find_by_id(id) is deprecated, use #get(name, id) instead [light_black](#{caller.first})[/]")
          self.find {|stack| stack.id == id}
        end

        def get(arg1, arg2 = nil)
          if arg2.nil?
            # Deprecated: get(id)
            Fog::Logger.deprecation("#get(id) is deprecated, use #get(name, id) instead [light_black](#{caller.first})[/]")
            return find_by_id(arg1)
          end

          # Normal use: get(name, id)
          name = arg1
          id = arg2
          data = service.show_stack_details(name, id).body['stack']
          new(data)
        rescue Fog::Compute::OpenStack::NotFound
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
