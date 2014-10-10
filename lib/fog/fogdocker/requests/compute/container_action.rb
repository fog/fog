module Fog
  module Compute
    class Fogdocker
      class Real
        def container_action(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.key? :id
          raise ArgumentError, "action is a required parameter" unless options.key? :action
          container = Docker::Container.get(options[:id])
          downcase_hash_keys container.send(options[:action]).json
        rescue Docker::Error::NotFoundError => e
          raise Fog::Errors::Error::NotFound.new(e.message)
        rescue Docker::Error::TimeoutError => e
          raise Fog::Errors::Error::TimeoutError.new(e.message)
        rescue Docker::Error::UnauthorizedError => e
          raise Fog::Errors::Fogdocker::ServiceError::AuthenticationError.new(e.message)
        rescue Docker::Error::DockerError => e
          raise Fog::Errors::Fogdocker::ServiceError.new(e.message)
        end
      end

      class Mock
        def container_action(options = {})
          raise ArgumentError, "id is a required parameter" unless options.key? :id
          raise ArgumentError, "action is a required parameter" unless options.key? :action
          {'id' => 'a6b02c7ca29a22619f7d0e59062323247739bc0cd375d619f305f0b519af4ef3','state_running' => false}
        end
      end
    end
  end
end
