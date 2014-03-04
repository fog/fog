module Fog
  module Compute
    class Fogdocker
      class Real

        def container_action(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.has_key? :id
          raise ArgumentError, "action is a required parameter" unless options.has_key? :action
          container = Docker::Container.get(options[:id])
          container.send(options[:action], options[:id]).info
        end

      end

      class Mock

        def container_action(options = {})
          raise ArgumentError, "id is a required parameter" unless options.has_key? :id
          raise ArgumentError, "action is a required parameter" unless options.has_key? :action
          {'id' => 'a6b02c7ca29a22619f7d0e59062323247739bc0cd375d619f305f0b519af4ef3','State' => {'Running' => false}}
        end

      end
    end
  end
end
