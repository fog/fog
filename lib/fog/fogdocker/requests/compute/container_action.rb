module Fog
  module Compute
    class Fogdocker
      class Real
        def container_action(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.key? :id
          raise ArgumentError, "action is a required parameter" unless options.key? :action
          result = Docker::Container.get(options[:id], {}, @connection).send(options[:action], options[:options] || {})

          if result.is_a?(Hash)
            downcase_hash_keys(result)
          else
            result
          end
        rescue Docker::Error::NotFoundError => e
          raise Fog::Errors::NotFound.new(e.message)
        rescue Docker::Error::TimeoutError => e
          raise Fog::Errors::TimeoutError.new(e.message)
        rescue Docker::Error::UnauthorizedError => e
          raise Fog::Errors::Fogdocker::AuthenticationError.new(e.message)
        rescue Docker::Error::DockerError => e
          raise Fog::Errors::Fogdocker::ServiceError.new(e.message)
        end
      end

      class Mock
        def container_action(options = {})
          raise ArgumentError, "id is a required parameter" unless options.key? :id
          raise ArgumentError, "action is a required parameter" unless options.key? :action
          response_matcher(options[:action])
        end

        private

        def response_matcher(action)
          send("#{action}_response".to_sym)
        rescue NoMethodError
          default_response
        end

        def default_response
          { 'id'           => 'a6b02c7ca29a22619f7d0e59062323247739bc0cd375d619f305f0b519af4ef3',
           'state_running' => false }
        end

        def start_response
          default_response.merge({ 'state_running' => true })
        end

        def top_response
          [
            {
              'UID'   => 'root',
              'PID'   => '15306',
              'PPID'  => '13567',
              'C'     => '0',
              'STIME' => 'Oct15',
              'TTY'   => '?',
              'TIME'  => '00:00:11',
              'CMD'   => 'ping theforeman.org'
            }
          ]
        end

        # Sample response from a ping
        def logs_response
          "\u0001\u0000\u0000\u0000\u0000\u0000\u0000]64 bytes from fra07s30-in-f6.1e100.net (173.194.112.102): icmp_req=35272 ttl=52 time=36.9 ms\n\u0001\u0000\u0000\u0000\u0000\u0000\u0000]64 bytes from fra07s30-in-f6.1e100.net (173.194.112.102): icmp_req=35273 ttl=52 time=35.3 ms\n"
        end
      end
    end
  end
end
