module Fog
  module Compute
    class Ovirt
      class Real
        def vm_action(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.key? :id
          raise ArgumentError, "action is a required parameter" unless options.key? :action

          client.vm_action options[:id], options[:action]
        end
      end

      class Mock
        def vm_action(options = {})
          raise ArgumentError, "id is a required parameter" unless options.key? :id
          raise ArgumentError, "action is a required parameter" unless options.key? :action
          true
        end
      end
    end
  end
end
